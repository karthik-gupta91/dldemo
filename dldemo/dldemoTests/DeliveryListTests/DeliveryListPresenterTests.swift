//
//  DeliveryListPresenterTests.swift
//  dldemoTests
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import XCTest
import CoreData
@testable import dldemo

class DeliveryListPresenterTests: XCTestCase {
    
    var presenter: DeliveryListPresenter!
    var view: PresenterToViewProtocol!
    var interactor: MockDLInteractor!
    var router: MockDLRouter!
    var viewController : MockDLVC!
    let networkManager = MockNetworkManager()
    
    override func setUp() {
        presenter = DeliveryListPresenter()
        
        viewController = MockDLVC(with: presenter)
        interactor = MockDLInteractor(with: presenter)
        router = MockDLRouter()
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        viewController.presenter = presenter
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //When network offline
    func testFetchDeliveryListWhenNetworkOfflineButFetchingError() {
        presenter.networkManager = networkManager
        interactor.list = nil
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, false)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.START_SPINNER_KEY]?.description, TestConstants.START_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_SPINNER_KEY]?.description, TestConstants.STOP_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.coreDataError.errorDescription)
    }
    
    func testFetchDeliveryListWhenOfflineDataEmpty() {
        presenter.networkManager = networkManager
        interactor.list = []
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, false)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.START_SPINNER_KEY]?.description, TestConstants.START_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_SPINNER_KEY]?.description, TestConstants.STOP_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.offlineError.errorDescription)
    }
    
    func testFetchDeliveryListWhenNetworkOfflineButCachePresent() {
        presenter.networkManager = networkManager
        interactor.list = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, false)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.START_SPINNER_KEY]?.description, TestConstants.START_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_SPINNER_KEY]?.description, TestConstants.STOP_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.RECIEVED_DELIVERY_LIST_VALUE)
    }
    
    func testFetchDeliveryListNetworkOfflineFetchingErrorAndRefreshData() {
        presenter.networkManager = networkManager
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, true)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY]?.description, TestConstants.STOP_PULL_REFRESH_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.coreDataError.errorDescription)
        
    }
    
    func testFetchDeliveryListNetworkOfflineDataEmptyAndRefreshData() {
        presenter.networkManager = networkManager
        interactor.list = []
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, true)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY]?.description, TestConstants.STOP_PULL_REFRESH_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.offlineError.errorDescription)
    }
    
    func testFetchDeliveryListNetworkOfflineButCacheAndRefreshData() {
        presenter.networkManager = networkManager
        interactor.list = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, true)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY]?.description, TestConstants.STOP_PULL_REFRESH_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.REFRESH_DELIVERY_LIST_VALUE)
    }
    
    
    //When network online
    func testFetchDeliveryListNetworkOnlineButNetworkError() {
        setTestForNetworkAvailable()
        interactor.simulateNetworkError = true
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, false)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.START_SPINNER_KEY]?.description, TestConstants.START_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_SPINNER_KEY]?.description, TestConstants.STOP_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.networkError.errorDescription)
    }
    
    func testFetchDeliveryListNetworkOnlineButJsonError() {
       setTestForNetworkAvailable()
        interactor.list = nil
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, false)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.START_SPINNER_KEY]?.description, TestConstants.START_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_SPINNER_KEY]?.description, TestConstants.STOP_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.decodingError.errorDescription)
    }
    
    func testFetchDeliveryListNetworkOnlineButDataNA() {
        setTestForNetworkAvailable()
        interactor.list = []
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, false)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.START_SPINNER_KEY]?.description, TestConstants.START_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_SPINNER_KEY]?.description, TestConstants.STOP_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.emptyDataError.errorDescription)
    }
    
    func testFetchDeliveryListNetworkOnline() {
        setTestForNetworkAvailable()
        interactor.list = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, false)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.START_SPINNER_KEY]?.description, TestConstants.START_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_SPINNER_KEY]?.description, TestConstants.STOP_SPINNER_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.RECIEVED_DELIVERY_LIST_VALUE)
    }
    
    
    
    
    func testFetchDeliveryListNetworkOnlineRefreshDataButNetworkError() {
        setTestForNetworkAvailable()
        interactor.simulateNetworkError = true
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, true)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY]?.description, TestConstants.STOP_PULL_REFRESH_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.networkError.errorDescription)
    }
    
    func testFetchDeliveryListNetworkOnlineRefreshDataButJsonError() {
        setTestForNetworkAvailable()
        interactor.list = nil
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, true)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY]?.description, TestConstants.STOP_PULL_REFRESH_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.decodingError.errorDescription)
    }
    
    func testFetchDeliveryListNetworkOnlineRefreshDataButDataNA() {
        setTestForNetworkAvailable()
        interactor.list = []
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, true)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY]?.description, TestConstants.STOP_PULL_REFRESH_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.emptyDataError.errorDescription)
    }
    
    func testFetchDeliveryListNetworkOnlineRefreshData() {
        setTestForNetworkAvailable()
        interactor.list = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)]
        self.presenter.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE,Constants.FETCH_LIMIT, true)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.STOP_PULL_REFRESH_KEY]?.description, TestConstants.STOP_PULL_REFRESH_VALUE)
        XCTAssertEqual(viewController.inputCallbackResults[TestConstants.DELIVERY_LIST_KEY]?.description, TestConstants.REFRESH_DELIVERY_LIST_VALUE)
    }
    
    func testShowDetailVC() {
        self.presenter.showDetailVC(for: TestUtility.mockInfo(TestConstants.FAKE_ID_ONE))
        XCTAssertEqual(router.inputCallbackResults[TestConstants.SHOW_DETAIL_VC_KEY]?.description, TestConstants.SHOW_DETAIL_VC_VALUE)
    }
    
    func setTestForNetworkAvailable() {
        networkManager.isAvailable = true
        presenter.networkManager = networkManager
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
