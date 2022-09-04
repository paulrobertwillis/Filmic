//
//  ImagesRepositoryTests.swift
//  MovieAppTests
//
//  Created by Paul on 03/09/2022.
//

import XCTest
@testable import MovieApp

class ImagesRepositoryTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private var dataTransferService: ImagesDataTransferServiceMock!
    private var sut: ImagesRepository!
    
    private var resultValue: Result<Data, Error>!
    private var task: URLSessionTask!
    private var request: URLRequest!
    
    private var expectedImageData: Data!
    private var returnedImageData: Data!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        self.dataTransferService = ImagesDataTransferServiceMock()
        self.sut = .init(dataTransferService: self.dataTransferService!)
        
        self.request = URLRequest(url: URL(string: "www.example.com")!)
    }
    
    override func tearDown() {
        self.dataTransferService = nil
        self.sut = nil
        
        self.resultValue = nil
        self.task = nil
        self.request = nil
                
        super.tearDown()
    }

    func test_successfulRequestToDataTransferService() {
        // given
        self.givenExpectedSuccessfulRequestToDataTransferService()
        
        // when
        self.whenRepositoryCalled()
        
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
        self.whenRepositoryCalled()

        // then
        self.thenEnsureFailureResultIsReturnedWithError()
        self.thenEnsureRepositoryCallsDataTransferServiceExactlyOnce()
        self.thenEnsureRepositoryPassesReceivedRequestToDataTransferService()
    }
    
    // MARK: - Given
    
    private func givenExpectedSuccessfulRequestToDataTransferService() {
        guard let image = try? self.loadImage(named: "TestImage") else {
            XCTFail("Image should be available for testing")
            return
        }
        self.expectedImageData = image.pngData()
        self.dataTransferService.requestCompletionReturnValue = .success(self.expectedImageData)
    }
    
    private func givenExpectedFailedRequestToDataTransferService() {
        self.dataTransferService.requestCompletionReturnValue = .failure(DataTransferError.missingData)
    }

    // MARK: - When
    
    func whenRepositoryCalled() {
        guard let request = self.request else {
            XCTFail("request must be non optional at this point of execution")
            return
        }
        
        self.task = self.sut?.getImage(request: request, decoder: RawDataResponseDecoder()) { result in
            self.resultValue = result
            self.returnedImageData = try? result.get()
        }
    }
    
    // MARK: - Then
    
    private func thenEnsureRepositoryCallsDataTransferServiceExactlyOnce() {
        XCTAssertEqual(self.dataTransferService?.requestCallsCount, 1)
    }
    
    private func thenEnsureExpectedObjectIsFetched() {
        let returnedValue = try? self.unwrapResult()
        XCTAssertEqual(self.expectedImageData, returnedValue)
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
    
    func loadImage(named name: String, ofType imageType: String = "png") throws -> UIImage {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: name, ofType: imageType) else {
            throw NSError(domain: "loadImage", code: 1, userInfo: nil)
        }
        guard let image = UIImage(contentsOfFile: path) else {
            throw NSError(domain: "loadImage", code: 2, userInfo: nil)
        }
        return image
    }
    
    private func unwrapResult() throws -> Data? {
        return try self.resultValue?.get()
    }

}
