//
//  GenresRepository.swift
//  MovieAppTests
//
//  Created by Paul on 27/06/2022.
//

import XCTest
@testable import MovieApp

class GenresRepositoryTests: XCTestCase {
            
    private var dataTransferService: GenresDataTransferServiceMock?
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
        super.setUp()
        
        self.dataTransferService = GenresDataTransferServiceMock()
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
        
    func test_successfulRequestToDataTransferService() {
        // given
        self.givenExpectedFailedRequestToCache()
        self.givenExpectedSuccessfulRequestToDataTransferService()
        
        // when
        self.whenRepositoryCalledToRequestGenres()
        
        // then
        self.thenEnsureExpectedObjectIsFetched()
        self.thenEnsureTaskIsReturned()
        self.thenEnsureResponseSavedToCache()
        self.thenEnsureRepositoryRequestsFromCacheExactlyOnce()
        self.thenEnsureRepositorySavesToCacheExactlyOnce()
        self.thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
        self.thenEnsureRepositoryPassesReceivedRequestToDataTransferService()
        self.thenEnsureRepositoryPassesReceivedRequestDTOToCache()
    }
    
    func test_failedRequestToDataTransferService() {
        // given
        self.givenExpectedFailedRequestToCache()
        self.givenExpectedFailedRequestToDataTransferService()

        // when
        self.whenRepositoryCalledToRequestGenres()

        // then
        self.thenEnsureFailureResultIsReturnedWithError()
        self.thenEnsureRepositoryDoesNotAttemptToSaveToCache()
        self.thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
        self.thenEnsureRepositoryPassesReceivedRequestToDataTransferService()
    }
    
    // MARK: - Caching
    
    func test_successfulRequestToCache() {
        // given
        self.givenExpectedSuccessfulRequestToCache()
        
        // when
        self.whenRepositoryCalledToRequestGenres()
        
        // then
        self.thenEnsureExpectedObjectIsFetched()
        self.thenEnsureRepositoryReturnsCorrectResponse()
        self.thenEnsureRepositoryDoesNotCallDataTransferService()
        self.thenEnsureRepositoryRequestsFromCacheExactlyOnce()
        self.thenEnsureRepositoryDoesNotAttemptToSaveToCache()
        self.thenEnsureRepositoryPassesReceivedRequestDTOToCache()
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
//        whenRepositoryCalledToRequestGenres()
//        whenRepositoryCalledToRequestGenres()
//
//        // then
//        XCTAssertEqual(self.sut?.cache.count, 1)
//    }
        
    // MARK: - Given

    private func givenExpectedFailedRequestToCache() {
        self.cache?.getResponseCompletionReturnValue = .failure(.readError)
    }
    
    private func givenExpectedSuccessfulRequestToCache() {
        self.expectedGenresResponseDTO = GenresResponseDTO.createStub()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!

        self.cache?.getResponseCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
    }

    private func givenExpectedSuccessfulRequestToDataTransferService() {
        self.expectedGenresResponseDTO = GenresResponseDTO.createStub()
        self.expectedGenres = (self.expectedGenresResponseDTO?.genres.map { $0.toDomain() })!
        
        self.dataTransferService?.requestCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
    }
    
    private func givenExpectedFailedRequestToDataTransferService() {
        self.dataTransferService?.requestCompletionReturnValue = .failure(DataTransferError.missingData)
    }
        
    // MARK: - When
    
    func whenRepositoryCalledToRequestGenres() {
        guard let request = self.request else {
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
    
    private func thenEnsureExpectedObjectIsFetched() {
        let returnedValue = try? self.unwrapResult()
        XCTAssertEqual(self.expectedGenres, returnedValue)
    }
    
    private func thenEnsureFailureResultIsReturnedWithError() {
        XCTAssertThrowsError(try unwrapResult(), "") { error in
            XCTAssertNotNil(error)
        }
    }
    
    private func thenEnsureTaskIsReturned() {
        XCTAssertNotNil(self.task)
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
    public static func createStub() -> GenresResponseDTO {
        GenresResponseDTO(genres: GenresResponseDTO.GenreDTO.createStubs())
    }
}

extension GenresResponseDTO.GenreDTO {
    public static func createStub() -> GenresResponseDTO.GenreDTO {
        let randomIdentifier = Int.random(in: 1...100)
        let randomString = String.random()
        
        return GenresResponseDTO.GenreDTO(id: randomIdentifier, name: randomString)
    }
    
    public static func createStubs() -> [GenresResponseDTO.GenreDTO] {
        var genreDTOs: [GenresResponseDTO.GenreDTO] = []

        for _ in Int.randomRange() {
            genreDTOs.append(GenresResponseDTO.GenreDTO.createStub())
        }
        
        return genreDTOs
    }
}
