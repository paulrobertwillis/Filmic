//
//  GenresRepository.swift
//  MovieAppTests
//
//  Created by Paul on 27/06/2022.
//

import Foundation
import XCTest
@testable import MovieApp

class GenresRepositoryTests: XCTestCase {
    
    enum GenresRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    private var networkService: NetworkServiceMock?
    private var sut: GenresRepository?
    private var resultValue: Result<[Genre], Error>?
    private var task: URLSessionTask?
    
    private let genres = [
        Genre(id: Genre.Identifier(50), name: "Genre1"),
        Genre(id: Genre.Identifier(100), name: "Genre2"),
    ]

    // MARK: - Setup
    
    override func setUp() {
        self.networkService = NetworkServiceMock()
    }
    
    override func tearDown() {
        self.networkService = nil
        self.sut = nil
        self.resultValue = nil
        self.task = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_GenresRepository_whenGetsMovieGenres_shouldCallNetworkOnce() {
        // given
        givenGenresRepositoryIsInitialised()
        
        // when
        whenGenresRepositoryRequestsGenres()
        
        // then
        thenEnsureNetworkCalledExactlyOnce()
    }
    
    func test_GenresRepository_whenSuccessfullyGetsMovieGenres_shouldReturnGenresWithSuccess() {
        // given
        givenExpectedSuccess()
        givenGenresRepositoryIsInitialised()
        
        // when
        whenGenresRepositoryRequestsGenres()
        
        // then
        thenEnsureGenresAreFetched()
    }
    
    func test_GenresRepository_whenFailsToGetMovieGenres_shouldReturnErrorWithFailure() {
        // given
        givenExpectedFailure()
        givenGenresRepositoryIsInitialised()
        
        // when
        whenGenresRepositoryRequestsGenres()
                
        // then
        thenEnsureFailureResultIsReturned()
    }
    
    func test_GenresRepository_whenGetsMovieGenres_shouldReturnTask() {
        givenGenresRepositoryIsInitialised()
        
        // when
        whenGenresRepositoryRequestsGenres()
                
        // then
        thenEnsureTaskIsReturned()
    }
    
    // MARK: - Given
        
    private func givenExpectedSuccess() {
        self.networkService?.requestCompletionReturnValue = .success(self.genres)
    }
    
    private func givenExpectedFailure() {
        self.networkService?.requestCompletionReturnValue = .failure(GenresRepositorySuccessTestError.failedFetching)
    }
    
    private func givenGenresRepositoryIsInitialised() {
        self.sut = GenresRepository(networkService: self.networkService!)
    }
    
    // MARK: - When
    
    func whenGenresRepositoryRequestsGenres() {
        self.task = self.sut?.getMovieGenres { result in
            self.resultValue = result
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureNetworkCalledExactlyOnce() {
        XCTAssertEqual(self.networkService?.requestCallsCount, 1)
    }
    
    private func thenEnsureGenresAreFetched() {
        let returnedGenres = try? unwrapResult()
        XCTAssertEqual(self.genres, returnedGenres)
    }
    
    private func thenEnsureFailureResultIsReturned() {
        XCTAssertThrowsError(try unwrapResult(), "A GenresRepositorySuccessTestError should have been thrown but no Error was thrown") { error in
            XCTAssertEqual(error as? GenresRepositorySuccessTestError, GenresRepositorySuccessTestError.failedFetching)
        }
    }
    
    private func thenEnsureTaskIsReturned() {
        XCTAssertNotNil(self.task)
    }
    
    // MARK: - Helpers
    
    private func unwrapResult() throws -> [Genre]? {
        return try self.resultValue?.get()
    }
}

private class NetworkServiceMock: NetworkServiceProtocol {
    
    // MARK: - request
    
    var requestCallsCount = 0
    var requestReturnValue: URLSessionTask? = URLSessionTask()
        
    // completion
    var requestCompletionReturnValue: ResultValue = .success([])

    func request(_ request: NetworkRequest, completion: CompletionHandler) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        completion(requestCompletionReturnValue)
        
        return requestReturnValue
    }
}
