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
    private var cache: GenresResponseStorageMock?
    private var sut: GenresRepository?
    private var resultValue: Result<[Genre], Error>?
    private var task: URLSessionTask?
    
    private var request: URLRequest?
    private var requestDTO: GenresRequestDTO!
    
    private var expectedGenresResponseDTO: GenresResponseDTO?
    private var expectedGenres: [Genre]?
    
    private var returnedGenresResponseDTO: GenresResponseDTO?
    private var returnedGenres: [Genre]?
    
    // MARK: - Setup
    
    override func setUp() {
        self.dataTransferService = GenresDataTransferMock()
        self.cache = GenresResponseStorageMock()
        self.sut = .init(dataTransferService: self.dataTransferService!, cache: self.cache!)
        
        self.request = URLRequest(url: URL(string: "www.example.com")!)
        self.requestDTO = .init(type: .movie)
    }
    
    override func tearDown() {
        self.dataTransferService = nil
        self.cache = nil
        self.sut = nil
        self.resultValue = nil
        self.task = nil
        
        self.request = nil
        self.requestDTO = nil
        
        self.expectedGenresResponseDTO = nil
        self.expectedGenres = nil
        
        self.returnedGenresResponseDTO = nil
        self.returnedGenres = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
        
    func test_Mapping_whenPerformsSuccessfulRequestToDataTransferService_shouldMapDTOToDomainObject() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureSuccessResultReturnValueIsMappedToDomainObject()
    }
    
    func test_ReturningGenres_whenPerformsSuccessfulRequestToDataTransferService_shouldReturnGenresInCompletionHandlerSuccessResult() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureGenresAreFetched()
    }
    
    func test_ReturningFailure_whenPerformsFailedRequestToDataTransferService_shouldReturnErrorInCompletionHandlerFailureResult() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedFailedRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()

        // then
        thenEnsureFailureResultIsReturnedWithError()
    }
    
    func test_ReturningTask_whenPerformsSuccessfulRequestToDataTransferService_shouldReturnTask() {
        // when
        givenExpectedFailedRequestToCache()
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureTaskIsReturned()
    }
    
    // MARK: - Tests: Caching
        
    func test_Caching_whenPerformsSuccessfulRequestToDataTransferService_shouldSaveResponseToCache() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureResponseSavedToCache()
    }
    
    func test_Caching_whenPerformsSuccessfulRequestToCache_shouldReturnCorrectResponse() {
        // given
        givenExpectedSuccessfulRequestToCache()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryReturnsCorrectResponse()
    }
        
    func test_DataTransferCallCount_whenPerformsSuccessfulRequestToCache_shouldNotCallDataTransferService() {
        // given
        givenExpectedSuccessfulRequestToCache()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryDoesNotCallDataTransferService()
    }
        
    func test_CacheCallCount_whenPerformsFailedRequestToCache_shouldRequestFromCacheExactlyOnce() {
        // given
        givenExpectedFailedRequestToCache()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryRequestsFromCacheExactlyOnce()
    }
    
    func test_CacheCallCount_whenPerformsSuccessfulRequestToCache_shouldRequestFromCacheExactlyOnce() {
        // given
        givenExpectedSuccessfulRequestToCache()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryRequestsFromCacheExactlyOnce()
    }

    func test_CacheSavingBehaviour_whenPerformsSuccessfulRequestToCache_shouldNotAttemptToSaveToCache() {
        // given
        givenExpectedSuccessfulRequestToCache()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryDoesNotAttemptToSaveToCache()
    }
    
    func test_DataTransferServiceCallCount_whenPerformsFailedRequestToCache_shouldCallDataTransferServiceExactlyOnce() {
        // given
        givenExpectedFailedRequestToCache()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
    }

    func test_DataTransferServiceCallCount_whenPerformsSuccessfulRequestToCache_shouldNotCallDataTransferService() {
        // given
        givenExpectedSuccessfulRequestToCache()
        
        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryDoesNotCallDataTransferService()
    }

    func test_CacheSavingBehaviour_whenPerformsFailedRequestToDataTransferService_shouldNotSaveToCache() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedFailedRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryDoesNotAttemptToSaveToCache()
    }

    func test_CacheCallCount_whenPerformsSuccessfulRequestToDataTransferService_shouldRequestFromCacheExactlyOnce() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryRequestsFromCacheExactlyOnce()
    }

    func test_CacheSavingBehaviour_whenPerformsSuccessfulRequestToDataTransferService_shouldSaveToCacheExactlyOnce() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositorySavesToCacheExactlyOnce()
    }

    func test_DataTransferServiceCallCount_whenPerformsFailedRequestToDataTransferService_shouldCallDataTransferServiceExactlyOnce() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedFailedRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
    }

    func test_DataTransferServiceCallCount_whenPerformsSuccessfulRequestToDataTransferService_shouldCallDataTransferServiceExactlyOnce() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
    }

    // sends request to cache for failed request
    func test_CacheRequesting_whenPerformsFailedRequestToCache_shouldPassCorrectRequestToCache() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()

        // then
        thenEnsureRepositoryPassesReceivedRequestDTOToCache()
    }
    
    // sends request to cache for successful request
    func test_CacheRequesting_whenPerformsSuccessfulRequestToCache_shouldPassCorrectRequestToCache() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryPassesReceivedRequestDTOToCache()
    }

    func test_DataTransferServiceRequesting_whenPerformsFailedRequestToDataTransferService_shouldPassCorrectRequestToDataTransferService() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedFailedRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryPassesReceivedRequestToDataTransferService()
    }
    
    func test_DataTransferServiceRequesting_whenPerformsSuccessfulRequestToDataTransferService_shouldPassCorrectRequestToDataTransferService() {
        // given
        givenExpectedFailedRequestToCache()
        givenExpectedSuccessfulRequestToDataTransferService()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureRepositoryPassesReceivedRequestToDataTransferService()
    }

    // successful cache response maps responseDTO to domain
    func test_Mapping_whenPerformsSuccessfulRequestToCache_shouldMapSuccessResultToDomainObject() {
        // given
        givenExpectedSuccessfulRequestToCache()

        // when
        whenGenresRepositoryCalledToRequestGenres()
        
        // then
        thenEnsureSuccessResultReturnValueIsMappedToDomainObject()
    }
    
    // TODO: Tests for:
    // tests around the task that is being returned
    
    // TODO: Create separate tests for GenresResponseStorage
    
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

    private func givenExpectedFailedRequestToCache() {
        self.cache?.getResponseCompletionReturnValue = .failure(.readError)
    }
    
    private func givenExpectedSuccessfulRequestToCache() {
        self.expectedGenresResponseDTO = GenresResponseDTO.createStubGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!

        self.cache?.getResponseCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
    }

    private func givenExpectedSuccessfulRequestToDataTransferService() {
        self.expectedGenresResponseDTO = GenresResponseDTO.createStubGenresResponseDTO()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.dataTransferService?.requestCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
    }
    
    private func givenExpectedFailedRequestToDataTransferService() {
        self.dataTransferService?.requestCompletionReturnValue = .failure(DataTransferError.missingData)
    }
        
    // MARK: - When
    
    func whenGenresRepositoryCalledToRequestGenres() {
        guard let request = request else {
            XCTFail("request must be non optional at this point of execution")
            return
        }
        
        self.task = self.sut?.getMovieGenres(request: request) { result in
            self.resultValue = result
            self.returnedGenres = try? result.get()
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureRepositoryCallsDataTransferServiceExactlyOnce() {
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
    
    private func thenEnsureSuccessResultReturnValueIsMappedToDomainObject() {
        let fetchedDomainObject = try? self.resultValue?.get()
        XCTAssertNotNil(fetchedDomainObject)
    }
    
    private func thenEnsureResponseSavedToCache() {
        XCTAssertEqual(self.cache?.saveReceivedResponseDTO, self.expectedGenresResponseDTO)
    }
    
    private func thenEnsureRepositoryReturnsCorrectResponse() {
        XCTAssertEqual(self.returnedGenres, self.expectedGenres)
    }

    private func thenEnsureRepositoryDoesNotCallDataTransferService() {
        XCTAssertEqual(self.dataTransferService?.requestCallsCount, 0)
    }
    
    private func thenEnsureRepositoryRequestsFromCacheExactlyOnce() {
        XCTAssertEqual(self.cache?.getResponseCallCount, 1)
    }

    private func thenEnsureRepositoryDoesNotAttemptToSaveToCache() {
        XCTAssertEqual(self.cache?.saveCallCount, 0)
    }
    
    private func thenEnsureRepositorySavesToCacheExactlyOnce() {
        XCTAssertEqual(self.cache?.saveCallCount, 1)
    }

    private func thenEnsureRepositoryPassesReceivedRequestDTOToCache() {
        XCTAssertEqual(self.cache?.getResponseReceivedRequestDTO, self.requestDTO)
    }

    private func thenEnsureRepositoryPassesReceivedRequestToDataTransferService() {
        XCTAssertEqual(self.dataTransferService?.requestReceivedRequest, self.request)
    }

    // MARK: - Helpers
    
    private func unwrapResult() throws -> [Genre]? {
        return try self.resultValue?.get()
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

extension GenresResponseDTO {
    public static func createStubGenresResponseDTO() -> GenresResponseDTO {
        GenresResponseDTO(genres: GenresResponseDTO.GenreDTO.createStubGenreDTOs())
    }
}

extension GenresResponseDTO.GenreDTO {
    public static func createStubGenreDTO() -> GenresResponseDTO.GenreDTO {
        let randomIdentifier = Int.random(in: 1...100)
        let randomString = String.random()
        
        return GenresResponseDTO.GenreDTO(id: randomIdentifier, name: randomString)
    }
    
    public static func createStubGenreDTOs() -> [GenresResponseDTO.GenreDTO] {
        var genreDTOs: [GenresResponseDTO.GenreDTO] = []

        for _ in Int.randomRange() {
            genreDTOs.append(GenresResponseDTO.GenreDTO.createStubGenreDTO())
        }
        
        return genreDTOs
    }

}
