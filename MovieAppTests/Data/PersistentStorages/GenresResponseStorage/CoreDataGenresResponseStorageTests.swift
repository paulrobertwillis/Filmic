//
//  CoreDataGenresResponseStorageTests.swift
//  MovieAppTests
//
//  Created by Paul on 14/07/2022.
//

import XCTest
import CoreData
@testable import MovieApp

class GenresResponseStorageTests: XCTestCase {
    
    // MARK: Private Properties
    
    private var coreDataStorage: CoreDataStorageMock!
    private var sut: CoreDataGenresResponseStorage!
    
    private var expectedGenresResponseDTO: GenresResponseDTO?
    private var returnedGenresResponseDTO: GenresResponseDTO?
    
    private var returnedError: CoreDataStorageError!
    
    private var request: URLRequest!
    private var requestDTO: GenresRequestDTO!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        self.coreDataStorage = CoreDataStorageMock()
        self.sut = CoreDataGenresResponseStorage(managedObjectContext: self.coreDataStorage.mainContext, coreDataStorage: self.coreDataStorage)
        
        self.expectedGenresResponseDTO = GenresResponseDTO.createStub()
        
        self.request = URLRequest(url: URL(string: "www.example.com")!)
        self.requestDTO = .init(type: .movie)
    }
    
    override func tearDown() {
        self.coreDataStorage = nil
        self.sut = nil
        
        self.expectedGenresResponseDTO = nil
        self.returnedGenresResponseDTO = nil
        
        self.request = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
//    func test_GettingResponse_whenStorageContainsMatchingResponseForRequest_shouldReturnCorrectResponseInSuccessResultValue() {
//        // given
//        self.sut.save(responseDTO: self.expectedGenresResponseDTO!, for: self.requestDTO)
//
//        // when
//        whenResponseRequested()
//
//        // then
//        thenEnsureCorrectResponseReturnedInSuccessReturnValue()
//    }
    
    func test_GettingResponse_givenStorageDoesNotContainMatchingResponseForRequest_whenResponseRequested_shouldReturnNilInSuccessResultValue() {
        // given
        givenGenresResponseStorageDoesNotContainMatchingResponseForRequest()
        
        // when
        whenResponseRequested()
        
        // then
        thenEnsureCorrectResponseReturnedInSuccessReturnValue()
    }
    
    func test_GettingResponse_whenCannotFetchResponseForRequest_shouldReturnErrorInFailureResultValue() {
        // when
        whenFailsToFetchResponse()
        
        // then
        thenEnsureCorrectErrorIsReturnedInFailureReturnValue()
    }
    
//    func test_SavingResponse_whenStorageDoesNotContainMatchingResponseForRequest_shouldSaveResponseToStorage() {
//        // when
//        whenResponseSaved()
//        whenResponseRequested()
//
//        // then
//        XCTAssertEqual(self.expectedGenresResponseDTO, self.returnedGenresResponseDTO)
//    }
    
    func test_SavingContext_whenStorageDoesNotContainMatchingResponseForRequest_shouldSaveResponseToStorage() {
        // given
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: self.coreDataStorage.mainContext) { _ in
                return true
            }
        
        // when
        self.coreDataStorage.mainContext.perform {
            self.sut.save(responseDTO: self.expectedGenresResponseDTO!, for: self.requestDTO)
        }
        
        // then
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    // TODO: Test emptyStorageError of CoreDataStorage
    
    
    
    
    // MARK: - Given
    
    private func givenGenresResponseStorageDoesNotContainMatchingResponseForRequest() {
        self.expectedGenresResponseDTO = nil
    }
    
    // MARK: - When
    
    private func whenResponseSaved() {
        self.sut.save(responseDTO: self.expectedGenresResponseDTO!, for: self.requestDTO)
    }
    
    private func whenResponseRequested() {
        self.sut.getResponse(for: self.requestDTO) { result in
            switch result {
            case .success(let genresResponseDTO):
                self.returnedGenresResponseDTO = genresResponseDTO
                print(">>> \(genresResponseDTO.genres)")
            case .failure(let error):
                self.returnedError = error
            }
        }
    }
    
    private func whenFailsToFetchResponse() {
        self.coreDataStorage.willFailToFetchResponse = true
        
        self.sut?.getResponse(for: self.requestDTO) { result in
            if case let .failure(error) = result {
                self.returnedError = error
            }
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureCorrectResponseReturnedInSuccessReturnValue() {
        XCTAssertEqual(self.expectedGenresResponseDTO, self.returnedGenresResponseDTO)
    }
    
    private func thenEnsureCorrectErrorIsReturnedInFailureReturnValue() {
        XCTAssertEqual(.readError, self.returnedError)
    }
}
