//
//  MoviesRepositoryTests.swift
//  MovieAppTests
//
//  Created by Paul on 03/09/2022.
//

import XCTest
@testable import MovieApp

class MoviesRepositoryTests: XCTestCase {

    // MARK: - Private Properties
    
    private var dataTransferService: MoviesDataTransferServiceMock!
    private var sut: MoviesRepository!
    
    private var resultValue: Result<MoviesPage, Error>?
    private var task: URLSessionTask!
    private var request: URLRequest!

    private var expectedMoviesResponseDTO: MoviesResponseDTO!
    private var expectedMoviesPage: MoviesPage!
    
    private var returnedMoviesResponseDTO: MoviesResponseDTO!
    private var returnedMoviesPage: MoviesPage!

    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        self.dataTransferService = MoviesDataTransferServiceMock()
        
        self.sut = MoviesRepository(dataTransferService: self.dataTransferService)
        
        self.request = URLRequest(url: URL(string: "www.example.com")!)
    }
    
    override func tearDown() {
        
        self.dataTransferService = nil

        self.sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_successfulRequestToDataTransferService() {
        // given
        self.givenExpectedSuccessfulRequestToDataTransferService()
        
        // when
        self.whenRepositoryCalledToRequestGenres()
        
        // then
        self.thenEnsureExpectedObjectIsFetched()
        self.thenEnsureTaskIsReturned()
        self.thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
        self.thenEnsureRepositoryPassesReceivedRequestToDataTransferService()
    }
    
    func test_failedRequestToDataTransferService() {
        // given
        self.givenExpectedFailedRequestToDataTransferService()

        // when
        self.whenRepositoryCalledToRequestGenres()

        // then
        self.thenEnsureFailureResultIsReturnedWithError()
        self.thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
        self.thenEnsureRepositoryPassesReceivedRequestToDataTransferService()
    }
    
    // MARK: - Given
    
    private func givenExpectedSuccessfulRequestToDataTransferService() {
        self.expectedMoviesResponseDTO = MoviesResponseDTO.createStub()
        self.expectedMoviesPage = self.expectedMoviesResponseDTO.toDomain()
        
        self.dataTransferService.requestCompletionReturnValue = .success(self.expectedMoviesResponseDTO!)
    }
    
    private func givenExpectedFailedRequestToDataTransferService() {
        self.dataTransferService.requestCompletionReturnValue = .failure(DataTransferError.missingData)
    }
    
    // MARK: - When
    
    private func whenRepositoryCalledToRequestGenres() {
        guard let request = self.request else {
            XCTFail("request must be non optional at this point of execution")
            return
        }
        
        self.task = self.sut.getMovies(request: request) { result in
            self.resultValue = result
            self.returnedMoviesPage = try? result.get()
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureRepositoryCallsDataTransferServiceExactlyOnce() {
        XCTAssertEqual(self.dataTransferService?.requestCallsCount, 1)
    }
    
    private func thenEnsureExpectedObjectIsFetched() {
        let returnedValue = try? self.unwrapResult()
        XCTAssertEqual(self.expectedMoviesPage, returnedValue)
    }
    
    private func thenEnsureFailureResultIsReturnedWithError() {
        XCTAssertThrowsError(try unwrapResult(), "") { error in
            XCTAssertNotNil(error)
        }
    }
    
    private func thenEnsureTaskIsReturned() {
        XCTAssertNotNil(self.task)
    }
    
    private func thenEnsureRepositoryPassesReceivedRequestToDataTransferService() {
        XCTAssertEqual(self.dataTransferService?.requestReceivedRequest, self.request)
    }
    
    // MARK: - Helpers
    
    private func unwrapResult() throws -> MoviesPage? {
        return try self.resultValue?.get()
    }
}

extension MoviesResponseDTO {
    public static func createStub() -> MoviesResponseDTO {
        MoviesResponseDTO(
            page: 1,
            results: MovieDTO.createStubs(),
            totalResults: 100,
            totalPages: 10
        )
    }
}

extension MoviesResponseDTO.MovieDTO {
    public static func createStub() -> MoviesResponseDTO.MovieDTO {
        MoviesResponseDTO.MovieDTO(
            adult: Bool.random(),
            backdropPath: String.random(),
            genreIds: [Int.random(in: 1...10)],
            id: Int.random(in: 1...5),
            originalLanguage: "English",
            originalTitle: "Title",
            overview: "Overview",
            popularity: 10,
            posterPath: String.random(),
            releaseDate: "2022-10-10",
            title: "Film Title",
            video: Bool.random(),
            voteAverage: Double.random(in: 1...10),
            voteCount: Int.random(in: 20...1000)
        )
    }
    
    public static func createStubs() -> [MoviesResponseDTO.MovieDTO] {
        var genreDTOs: [MoviesResponseDTO.MovieDTO] = []

        for _ in Int.randomRange() {
            genreDTOs.append(MoviesResponseDTO.MovieDTO.createStub())
        }
        
        return genreDTOs
    }
}
