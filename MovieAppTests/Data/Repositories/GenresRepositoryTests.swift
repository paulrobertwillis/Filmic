//
//  GenresRepository.swift
//  MovieAppTests
//
//  Created by Paul on 27/06/2022.
//

import XCTest
@testable import MovieApp

class GenresRepositoryTests: XCTestCase {
    
    private enum GenresRepositoryTestsError: Error {
        case someError
    }
        
    private var dataTransferService: GenresDataTransferMock?
    private var cache: GenresResponseStorageMock?
    private var sut: GenresRepository?
    private var resultValue: Result<[Genre], Error>?
    private var task: URLSessionTask?
    
    private var expectedGenresResponseDTO: GenresResponseDTO?
    private var expectedGenres: [Genre]?
    
    private var returnedGenresResponseDTO: GenresResponseDTO?
    private var returnedGenres: [Genre]?
    
    // MARK: - Setup
    
    override func setUp() {
        self.dataTransferService = GenresDataTransferMock()
        self.cache = GenresResponseStorageMock()
        self.sut = .init(dataTransferService: self.dataTransferService!, cache: self.cache!)
    }
    
    override func tearDown() {
        self.dataTransferService = nil
        self.cache = nil
        self.sut = nil
        self.resultValue = nil
        self.task = nil
        
        self.expectedGenresResponseDTO = nil
        self.expectedGenres = nil
        
        self.returnedGenresResponseDTO = nil
        self.returnedGenres = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_DataTransferServiceCallCount_whenPerformsFailedRequestToCache_shouldCallDataTransferServiceExactlyOnce() {
        // given
        // givenNoGenresInCache
        self.cache?.getResponseCompletionReturnValue = .failure(GenresRepositoryTestsError.someError)
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureDataTransferServiceCalledExactlyOnce()
    }
    
    func test_Mapping_whenPerformsSuccessfulRequestToDataTransferService_shouldMapDTOToDomainObject() {
        // given
        self.cache?.getResponseCompletionReturnValue = .failure(GenresRepositoryTestsError.someError)
        givenExpectedSuccessOfDataTransferService()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureDTOIsMappedToDomainObject()
    }
    
    func test_ReturningGenres_whenPerformsSuccessfulRequestToDataTransferService_shouldReturnGenresInCompletionHandlerSuccessResult() {
        // given
        self.cache?.getResponseCompletionReturnValue = .failure(GenresRepositoryTestsError.someError)
        givenExpectedSuccessOfDataTransferService()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureGenresAreFetched()
    }
    
    func test_ReturningFailure_whenPerformsFailedRequestToDataTransferService_shouldReturnErrorInCompletionHandlerFailureResult() {
        // given
        self.cache?.getResponseCompletionReturnValue = .failure(GenresRepositoryTestsError.someError)
        givenExpectedFailureOfDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()

        // then
        thenEnsureFailureResultIsReturnedWithError()
    }
    
    func test_ReturningTask_whenSuccessfullyGetsMovieGenres_shouldReturnTask() {
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureTaskIsReturned()
    }
    
    // MARK: - Tests: Caching
        
    func test_Caching_whenSuccessfullyGetsMovieGenres_shouldSaveResponseToCache() {
        // given
        self.cache?.getResponseCompletionReturnValue = .failure(GenresRepositoryTestsError.someError)
        givenExpectedSuccessOfDataTransferService()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        XCTAssertEqual(self.cache?.saveReceivedResponse, self.expectedGenresResponseDTO)
    }
    
    func test_Caching_whenCalledToGetMovieGenres_shouldReturnResponseFromCacheIfMatchingResponseIsCached() {
        // given
        self.expectedGenresResponseDTO = self.createGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.cache?.getResponseCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        XCTAssertEqual(self.returnedGenres, self.expectedGenres)
    }
    
    func test_DataTransferCallCount_whenPerformsSuccessfulRequestToCache_shouldNotCallDataTransferService() {
        // given
        self.expectedGenresResponseDTO = self.createGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.cache?.getResponseCompletionReturnValue = .success(self.expectedGenresResponseDTO!)

        // when
        whenGenresRepositoryCalledToRequestGenres()

        // then
        XCTAssertEqual(self.dataTransferService?.requestCallsCount, 0)
    }
    
    // TODO: Move this to testing of GenresResponseStorage
//    func test_Caching_whenCalledMultipleTimesToGetMovieGenres_shouldHaveExactlyOneGenresResponseDTOCached() {
//        // given
//        self.expectedGenresResponseDTO = self.createGenresResponseDTO()
//        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
//
//        self.sut?.cache.append(self.expectedGenresResponseDTO!)
//
//        // when
//        whenGenresRepositoryCalledToRequestGenres()
//        whenGenresRepositoryCalledToRequestGenres()
//
//        // then
//        XCTAssertEqual(self.sut?.cache.count, 1)
//    }
        
    // MARK: - Given
        
    private func givenExpectedSuccessOfDataTransferService() {
        self.expectedGenresResponseDTO = self.createGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.dataTransferService?.requestCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
    }
    
    private func givenExpectedFailureOfDataTransferService() {
        self.dataTransferService?.requestCompletionReturnValue = .failure(DataTransferError.missingData)
    }
        
    // MARK: - When
    
    func whenGenresRepositoryCalledToRequestGenres() {
        self.task = self.sut?.getMovieGenres { result in
            self.resultValue = result
            self.returnedGenres = try? result.get()
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureDataTransferServiceCalledExactlyOnce() {
        XCTAssertEqual(self.dataTransferService?.requestCallsCount, 1)
    }
    
    private func thenEnsureGenresAreFetched() {
        let returnedGenres = try? unwrapResult()
        XCTAssertEqual(self.expectedGenres, returnedGenres)
    }
    
    private func thenEnsureFailureResultIsReturnedWithError() {
        XCTAssertThrowsError(try unwrapResult(), "") { error in
            XCTAssertNotNil(error)
        }
    }
    
    private func thenEnsureTaskIsReturned() {
        XCTAssertNotNil(self.task)
    }
    
    private func thenEnsureDTOIsMappedToDomainObject() {
        let fetchedDomainObject = try? self.resultValue?.get()
        XCTAssertNotNil(fetchedDomainObject)
    }
    
    // MARK: - Helpers
    
    private func unwrapResult() throws -> [Genre]? {
        return try self.resultValue?.get()
    }
    
    // MARK: - Creation
    
    private func createAGenreDTO() -> GenresResponseDTO.GenreDTO {
        let randomIdentifier = Int.random(in: 1...100)
        let randomString = String.random()
        
        return GenresResponseDTO.GenreDTO(id: randomIdentifier, name: randomString)
    }
    
    private func createGenreDTOs() -> [GenresResponseDTO.GenreDTO] {
        var genreDTOs: [GenresResponseDTO.GenreDTO] = []

        for _ in Int.randomRange() {
            genreDTOs.append(self.createAGenreDTO())
        }
        
        return genreDTOs
    }
    
    private func createGenresResponseDTO() -> GenresResponseDTO {
        GenresResponseDTO(genres: self.createGenreDTOs())
    }
}

extension String {

    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}

extension Int {
    
    static func randomRange(upto endValue: Int = 10) -> ClosedRange<Int> {
        let randomInt = Int.random(in: 1...endValue)
        return 1...randomInt
    }
}
