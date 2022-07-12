//
//  GenresRepository.swift
//  MovieAppTests
//
//  Created by Paul on 27/06/2022.
//

import XCTest
@testable import MovieApp

class GenresRepositoryTests: XCTestCase {
    
//    typealias GenreDataTransferServiceMock = DataTransferServiceMock<GenresResponseDTO>
        
    private var dataTransferService: GenresDataTransferMock?
    private var sut: GenresRepository?
    private var resultValue: Result<[Genre], Error>?
    private var task: URLSessionTask?
    
    private var expectedGenresResponseDTO: GenresResponseDTO?
    private var expectedGenres = [Genre(id: Genre.Identifier(28), name: "Action")]
    
    private var returnedGenresResponseDTO: GenresResponseDTO?
    
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
        
        self.returnedGenresResponseDTO = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_DataTransferServiceCallCount_whenGetsMovieGenres_shouldCallDataTransferServiceOnce() {
        // when
        whenGenresRepositoryRequestsGenres()
        
        // then
        thenEnsureDataTransferServiceCalledExactlyOnce()
    }
    
    func test_Mapping_whenSuccessfullyGetsResultFromDataTransferService_shouldMapDTOToDomainObject() {
        // given
        givenExpectedSuccess()
        
        // when
        whenGenresRepositoryRequestsGenres()
        
        // then
        thenEnsureDTOIsMappedToDomainObject()
    }
    
    func test_ReturningGenres_whenSuccessfullyGetsResultFromDataTransferService_shouldReturnGenresWithSuccess() {
        // given
        givenExpectedSuccess()
        
        // when
        whenGenresRepositoryRequestsGenres()
        
        // then
        thenEnsureGenresAreFetched()
    }
    
    func test_ReturningFailure_whenFailsToGetMovieGenres_shouldReturnFailureResultWithError() {
        // given
        givenExpectedFailure()

        // when
        whenGenresRepositoryRequestsGenres()

        // then
        thenEnsureFailureResultIsReturnedWithError()
    }
    
    func test_ReturningTask_whenGetsMovieGenres_shouldReturnTask() {
        // when
        whenGenresRepositoryRequestsGenres()
                
        // then
        thenEnsureTaskIsReturned()
    }
    
    // MARK: - Tests: Caching
    
    
    
    // MARK: - Given
        
    private func givenExpectedSuccess() {
        self.expectedGenresResponseDTO = GenresResponseDTO(genres: [
                                                                GenresResponseDTO.GenreDTO(id: 28, name: "Action")
                                                            ])
        self.dataTransferService?.requestCompletionReturnValue = .success(self.expectedGenresResponseDTO!)
    }
    
    private func givenExpectedFailure() {
        self.dataTransferService?.requestCompletionReturnValue = .failure(DataTransferError.missingData)
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
}
