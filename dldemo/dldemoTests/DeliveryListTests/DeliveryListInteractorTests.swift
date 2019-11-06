//
//  DeliveryListInteractorTests.swift
//  dldemoTests
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import XCTest
import CoreData
@testable import dldemo

class DeliveryListInteractorTests: XCTestCase {
    
    var interactor: DeliveryListInterator!
    var mockPresenter: MockDLPresenter!
    var mockClient: MockRemoteClient!
    var mockCdProtocol: MockCDProtocol!
    
    override func setUp() {
        self.mockPresenter = MockDLPresenter()
        self.mockClient = MockRemoteClient()
        self.mockCdProtocol = MockCDProtocol()
        self.interactor = DeliveryListInterator(remoteClient: mockClient, presenter: mockPresenter, cdProtocol: mockCdProtocol)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchDataOfflineWhenDataFetchingError() {
        self.mockCdProtocol.list = nil
        self.interactor.fetchOfflineCache(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.coreDataError.errorDescription)
    }
    
    func testFetchDataOfflineWhenDataEmpty() {
        self.mockCdProtocol.list = []
        self.interactor.fetchOfflineCache(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.offlineError.errorDescription)
    }
    
    func testFetchDataOfflineWhenDataAvailable() {
        self.mockCdProtocol.list = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.interactor.fetchOfflineCache(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.FETCH_DELIVERY_LIST_VALUE)
    }
    
    func testFetchDataOnlineWhenDataEmpty() {
        self.mockClient.deliveryList = []
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.emptyDataError.errorDescription)
    }
    
    func testFetchDataOnlineWhenDataAvailable() {
        self.mockClient.deliveryList = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.FETCH_DELIVERY_LIST_VALUE)
    }
    
    func testFetchOfflineWhenOnlineDecodingErrorListNil() {
        self.mockClient.wrongDecoding = true
        self.mockCdProtocol.list = nil
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.coreDataError.errorDescription)
    }
    
    func testFetchOfflineWhenOnlineDecodingErrorListEmpty() {
        self.mockClient.wrongDecoding = true
        self.mockCdProtocol.list = []
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.decodingError.errorDescription)
    }
    
    func testFetchOfflineWhenOnlineDecodingErrorListAvailable() {
        self.mockClient.wrongDecoding = true
        self.mockCdProtocol.list = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.FETCH_DELIVERY_LIST_VALUE)
    }
    
    func testFetchOfflineWhenOnlineNetworkErrorListNil() {
        self.mockClient.simulateNetworkError = true
        self.mockCdProtocol.list = nil
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.coreDataError.errorDescription)
    }
    
    func testFetchOfflineWhenOnlineNetworkErrorListEmpty() {
        self.mockClient.simulateNetworkError = true
        self.mockCdProtocol.list = []
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.networkError.errorDescription)
    }
    
    func testFetchOfflineWhenOnlineNetworkErrorListAvailable() {
        self.mockClient.simulateNetworkError = true
        self.mockCdProtocol.list = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.interactor.fetchDataOnline(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
        XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.FETCH_DELIVERY_LIST_VALUE)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
