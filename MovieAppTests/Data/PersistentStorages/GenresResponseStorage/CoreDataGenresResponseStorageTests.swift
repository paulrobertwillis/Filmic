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
    
    private var coreDataStorage: CoreDataStorageMock?
    private var sut: CoreDataGenresResponseStorage?
    
    private var expectedGenresResponseDTO: GenresResponseDTO?
    private var returnedGenresResponseDTO: GenresResponseDTO?
    
    private var returnedError: CoreDataStorageError?
    
    private var request: URLRequest?
    private var requestDTO: GenresRequestDTO!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        self.coreDataStorage = CoreDataStorageMock()
        
        self.sut = CoreDataGenresResponseStorage(coreDataStorage: self.coreDataStorage!)
        
        self.expectedGenresResponseDTO = GenresResponseDTO.createStubGenresResponseDTO()

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
    
    func test_GettingResponse_whenStorageContainsMatchingResponseForRequest_shouldReturnCorrectResponseInSuccessResultValue() {
        // given
        givenGenresResponseStorageContainsMatchingResponseForRequest()
        
        // when
        whenResponseRequested()
        
        // then
        thenEnsureCorrectResponseReturnedInSuccessReturnValue()
    }
    
    func test_GettingResponse_whenStorageDoesNotContainMatchingResponseForRequest_shouldReturnErrorInFailureResultValue() {
        // when
        whenResponseRequested()
        
        // then
        thenEnsureCorrectErrorIsReturnedInFailureReturnValue()
    }
    
    // if storage does not contain matching response for request, save response
    func test_SavingResponse_whenStorageDoesNotContainMatchingResponseForRequest_shouldSaveResponseToStorage() {
        // when
        whenResponseSaved()
        whenResponseRequested()
        
        // then
        guard
            let expectedGenresResponseDTO = expectedGenresResponseDTO,
            let returnedGenresResponseDTO = returnedGenresResponseDTO
        else {
            XCTFail("expected and returned GenresResponseDTOs should be non optional at this point of execution")
            return
        }

        XCTAssertEqual(expectedGenresResponseDTO, returnedGenresResponseDTO)
    }
    
    // MARK: - Given
    
    private func givenGenresResponseStorageContainsMatchingResponseForRequest() {
        self.sut?.save(response: self.expectedGenresResponseDTO!, for: self.requestDTO)
    }
    
    // MARK: - When
    
    private func whenResponseSaved() {
        self.sut?.save(response: self.expectedGenresResponseDTO!, for: self.requestDTO)
    }
    
    private func whenResponseRequested() {
        guard let requestDTO = self.requestDTO else {
            XCTFail("request should be non optional at this point of execution")
            return
        }
        
        self.sut?.getResponse(for: requestDTO) { result in
            switch result {
            case .success(let genresResponseDTO):
                self.returnedGenresResponseDTO = genresResponseDTO
            case .failure(let error):
                self.returnedError = error
            }
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureCorrectResponseReturnedInSuccessReturnValue() {
        guard
            let expectedGenresResponseDTO = expectedGenresResponseDTO,
            let returnedGenresResponseDTO = returnedGenresResponseDTO
        else {
            XCTFail("expected and returned GenresResponseDTOs should be non optional at this point of execution")
            return
        }

        XCTAssertEqual(expectedGenresResponseDTO, returnedGenresResponseDTO)
    }
    
    private func thenEnsureCorrectErrorIsReturnedInFailureReturnValue() {
        XCTAssertEqual(.readError, self.returnedError)
    }
}
