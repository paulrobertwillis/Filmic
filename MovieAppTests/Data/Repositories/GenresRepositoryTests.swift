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
    
    private var dataTransferService: DataTransferServiceMock?
    private var sut: GenresRepository?
    private var resultValue: Result<[Genre], Error>?
    private var task: URLSessionTask?
    
    private let genres = [
        Genre(id: Genre.Identifier(50), name: "Genre1"),
        Genre(id: Genre.Identifier(100), name: "Genre2"),
    ]

    // MARK: - Setup
    
    override func setUp() {
        self.dataTransferService = DataTransferServiceMock()
    }
    
    override func tearDown() {
        self.dataTransferService = nil
        self.sut = nil
        self.resultValue = nil
        self.task = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_GenresRepository_whenGetsMovieGenres_shouldCallDataTransferServiceOnce() {
        // given
        givenGenresRepositoryIsInitialised()
        
        // when
        whenGenresRepositoryRequestsGenres()
        
        // then
        thenEnsureDataTransferServiceCalledExactlyOnce()
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
    
    // TODO: Find out how to refactor to include errors
//    func test_GenresRepository_whenFailsToGetMovieGenres_shouldReturnErrorWithFailure() {
//        // given
//        givenExpectedFailure()
//        givenGenresRepositoryIsInitialised()
//
//        // when
//        whenGenresRepositoryRequestsGenres()
//
//        // then
//        thenEnsureFailureResultIsReturned()
//    }
    
    func test_GenresRepository_whenGetsMovieGenres_shouldReturnTask() {
        givenGenresRepositoryIsInitialised()
        
        // when
        whenGenresRepositoryRequestsGenres()
                
        // then
        thenEnsureTaskIsReturned()
    }
    
    // MARK: - Given
        
    private func givenExpectedSuccess() {
        self.dataTransferService?.requestCompletionReturnValue = .success(self.genresStub)
    }
    
    private func givenExpectedFailure() {
        self.dataTransferService?.requestCompletionReturnValue = .failure(DataTransferError.missingData)
    }
    
    private func givenGenresRepositoryIsInitialised() {
        self.sut = GenresRepository(dataTransferService: self.dataTransferService!)
    }
    
    // MARK: - When
    
    func whenGenresRepositoryRequestsGenres() {
        self.task = self.sut?.getMovieGenres { result in
            self.resultValue = result
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureDataTransferServiceCalledExactlyOnce() {
        XCTAssertEqual(self.dataTransferService?.requestCallsCount, 1)
    }
    
    private func thenEnsureGenresAreFetched() {
        let returnedGenres = try? unwrapResult()
        XCTAssertEqual(self.genres, returnedGenres)
    }
    
//    private func thenEnsureFailureResultIsReturned() {
//        XCTAssertThrowsError(try unwrapResult(), "A GenresRepositorySuccessTestError should have been thrown but no Error was thrown") { error in
//            XCTAssertEqual(error as? NetworkError, NetworkError.someError)
//        }
//    }
    
    private func thenEnsureTaskIsReturned() {
        XCTAssertNotNil(self.task)
    }
    
    // MARK: - Helpers
    
    private func unwrapResult() throws -> [Genre]? {
        return try self.resultValue?.get()
    }
    
    private let genresStub: [Genre] = [
        Genre(id: Genre.Identifier(50), name: "Genre1"),
        Genre(id: Genre.Identifier(100), name: "Genre2"),
    ]
}


//var requestCallsCount = 0
//var requestReturnValue: URLSessionTask? = URLSessionTask()
//
//// request parameter
//var requestReceivedRequest: URLRequest?
//
//// completion parameter
//var requestCompletionReturnValue: ResultValue = .success(nil)
//
//func request(request: URLRequest, completion: CompletionHandler) -> URLSessionTask? {
//    self.requestCallsCount += 1
//
//    self.requestReceivedRequest = request
//
//    completion(requestCompletionReturnValue)
//
//    return requestReturnValue
//}
