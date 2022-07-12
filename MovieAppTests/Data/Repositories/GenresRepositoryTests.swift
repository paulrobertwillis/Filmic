//
//  GenresRepository.swift
//  MovieAppTests
//
//  Created by Paul on 27/06/2022.
//

import XCTest
@testable import MovieApp

class GenresRepositoryTests: XCTestCase {
        
    private var dataTransferService: GenresDataTransferMock?
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
        self.sut = .init(dataTransferService: self.dataTransferService!)
    }
    
    override func tearDown() {
        self.dataTransferService = nil
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
    
    func test_DataTransferServiceCallCount_whenGetsMovieGenres_shouldCallDataTransferServiceOnce() {
        // when
        whenGenresRepositoryCalledToRequestsGenres()
        
        // then
        thenEnsureDataTransferServiceCalledExactlyOnce()
    }
    
    func test_Mapping_whenSuccessfullyGetsResult_shouldMapDTOToDomainObject() {
        // given
        givenExpectedSuccess()
        
        // when
        whenGenresRepositoryCalledToRequestsGenres()
        
        // then
        thenEnsureDTOIsMappedToDomainObject()
    }
    
    func test_ReturningGenres_whenSuccessfullyGetsResult_shouldReturnGenresWithSuccess() {
        // given
        givenExpectedSuccess()
        
        // when
        whenGenresRepositoryCalledToRequestsGenres()
        
        // then
        thenEnsureGenresAreFetched()
    }
    
    func test_ReturningFailure_whenFailsToGetMovieGenres_shouldReturnFailureResultWithError() {
        // given
        givenExpectedFailure()

        // when
        whenGenresRepositoryCalledToRequestsGenres()

        // then
        thenEnsureFailureResultIsReturnedWithError()
    }
    
    func test_ReturningTask_whenSuccessfullyGetsMovieGenres_shouldReturnTask() {
        // when
        whenGenresRepositoryCalledToRequestsGenres()
        
        // then
        thenEnsureTaskIsReturned()
    }
    
    // MARK: - Tests: Caching
        
    func test_Caching_whenSuccessfullyGetsMovieGenres_shouldCacheResponse() {
        // given
        givenExpectedSuccess()
        
        // when
        whenGenresRepositoryCalledToRequestsGenres()
        
        // then
        XCTAssertEqual(self.sut?.cache.count, 1)
    }
    
    func test_Caching_whenCalledToGetMovieGenres_shouldReturnResponseFromCacheIfMatchingResponseIsCached() {
        // given
        self.expectedGenresResponseDTO = self.createGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.sut?.cache.append(self.expectedGenresResponseDTO!)
        
        // when
        whenGenresRepositoryCalledToRequestsGenres()
        
        // then
        XCTAssertEqual(self.returnedGenres, self.expectedGenres)
        XCTAssertEqual(self.dataTransferService?.requestCallsCount, 0)
    }
    
    func test_Caching_whenCalledMultipleTimesToGetMovieGenres_shouldHaveExactlyOneGenresResponseDTOCached() {
        // given
        self.expectedGenresResponseDTO = self.createGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.sut?.cache.append(self.expectedGenresResponseDTO!)
        
        // when
        whenGenresRepositoryCalledToRequestsGenres()
        whenGenresRepositoryCalledToRequestsGenres()

        // then
        XCTAssertEqual(self.sut?.cache.count, 1)
    }
        
    // MARK: - Given
        
    private func givenExpectedSuccess() {
        self.expectedGenresResponseDTO = self.createGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.dataTransferService?.requestCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
    }
    
    private func givenExpectedFailure() {
        self.dataTransferService?.requestCompletionReturnValue = .failure(DataTransferError.missingData)
    }
        
    // MARK: - When
    
    func whenGenresRepositoryCalledToRequestsGenres() {
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
