//
//  GetMovieGenresUseCaseTests.swift
//  MovieAppTests
//
//  Created by Paul on 21/06/2022.
//

import Foundation
import XCTest
@testable import MovieApp

class GetMovieGenresUseCaseTests: XCTestCase {
    
    enum GetMovieGenresUseCaseSuccessTestError: Error {
        case failedFetching
    }
    
    private var repository: GenresRepositoryMock?
    private var sut: GetMovieGenresUseCase?
    private var resultValue: GenresRepositoryProtocol.ResultValue?
    private var task: URLSessionTask?
    
    private let genres = [
        Genre(id: Genre.Identifier(50), name: "Genre1"),
        Genre(id: Genre.Identifier(100), name: "Genre2"),
    ]
    
    // MARK: - Setup
    override func setUp() {
        self.repository = GenresRepositoryMock()
    }
    
    override func tearDown() {
        self.repository = nil
        self.sut = nil
        self.resultValue = nil
        self.task = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    // TODO: Returns success without caring about genres; returns task; can return nil for task
    
    func test_GetMovieGenresUseCase_whenExecutes_shouldCallRepositoryOnce() {
        // given
        givenUseCaseIsInitialised()
        
        // when
        whenUseCaseRequestsGenres()

        // then
        thenEnsureRepositoryIsCalledExactlyOnce()
    }
    
    func test_GetMovieGenresUseCase_whenSuccessfullyGetsMovieGenres_shouldReturnGenresWithSuccess() {
        // given
        givenExpectedSuccess()
        givenUseCaseIsInitialised()
             
        // when
        whenUseCaseRequestsGenres()
        
        // then
        thenEnsureGenresAreFetched()
    }
    
    func test_GetMovieGenresUseCase_whenFailsToGetMovieGenres_shouldReturnErrorWithFailure() {
        // given
        givenExpectedFailure()
        givenUseCaseIsInitialised()
        
        // when
        whenUseCaseRequestsGenres()
        
        // then
        thenEnsureFailureResultIsReturned()
    }
    
    func test_GetMovieGenresUseCase_whenGetsMovieGenres_shouldReturnTask() {
        // given
        givenUseCaseIsInitialised()
        
        // when
        whenUseCaseRequestsGenres()
        
        // then
        thenEnsureTaskIsReturned()
    }

    // MARK: - Given

    private func givenExpectedSuccess() {
        self.repository?.getMovieGenresCompletionResultValue = .success(self.genres)
    }
    
    private func givenExpectedFailure() {
        self.repository?.getMovieGenresCompletionResultValue = .failure(GetMovieGenresUseCaseSuccessTestError.failedFetching)
    }

    private func givenUseCaseIsInitialised() {
        self.sut = GetMovieGenresUseCase(repository: repository!)
    }
    
    // MARK: - When
    
    private func whenUseCaseRequestsGenres() {
        self.task = self.sut?.execute { result in
            self.resultValue = result
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureRepositoryIsCalledExactlyOnce() {
        XCTAssertEqual(self.repository?.getMovieGenresCallsCount, 1)
    }
    
    private func thenEnsureGenresAreFetched() {
        let returnedGenres = try? unwrapResult()
        XCTAssertEqual(self.genres, returnedGenres)
    }
    
    private func thenEnsureFailureResultIsReturned() {
        XCTAssertThrowsError(try unwrapResult(), "A GenresRepositorySuccessTestError should have been thrown but no Error was thrown") { error in
            XCTAssertEqual(error as? GetMovieGenresUseCaseSuccessTestError, GetMovieGenresUseCaseSuccessTestError.failedFetching)
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

private class GenresRepositoryMock: GenresRepositoryProtocol {
    
    // MARK: - getMovieGenres
    
    var getMovieGenresCallsCount = 0
    var getMovieGenresReturnValue: URLSessionTask?
    var getMovieGenresClosure: ((CompletionHandler) -> URLSessionTask)?
    
    // completion parameter
    var getMovieGenresCompletionResultValue: ResultValue? = .success([])
    var getMovieGenresReceivedCompletion: CompletionHandler? = { _ in }
    
    func getMovieGenres(completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.getMovieGenresCallsCount += 1

        self.getMovieGenresReceivedCompletion = completion
        completion(getMovieGenresCompletionResultValue!)
        
        return getMovieGenresClosure.map({ $0(completion) }) ?? getMovieGenresReturnValue
    }
}
