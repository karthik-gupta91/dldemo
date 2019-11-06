//
//  DeliveryListVCTests.swift
//  dldemoTests
//
//  Created by kartik on 31/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import XCTest
@testable import dldemo

class DeliveryListViewTests: XCTestCase {

    var viewController: DeliveryListVC!
    var mockPresenter: MockDLPresenter!
    
    
    override func setUp() {
        mockPresenter = MockDLPresenter()
        viewController = DeliveryListVC(with: mockPresenter)
        mockPresenter.view = viewController
        mockPresenter.router = MockDLRouter()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewDidLoad() {
        viewController.viewDidLoad()
        XCTAssertEqual(viewController!.title?.description,Constants.DELIVERY_LIST_TITLE)
        XCTAssertTrue(viewController.tableView.delegate != nil)
    }
    
    func testFetchDataWhenNewDataNotAvailable() {
        mockPresenter.dataNA = true
        let deliveryList = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE),TestUtility.mockInfo(TestConstants.FAKE_ID_TWO),TestUtility.mockInfo(TestConstants.FAKE_ID_THREE)]
        viewController.deliveryList = deliveryList
        mockPresenter.list = viewController.deliveryList
        viewController.presenter?.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, false)
        XCTAssertTrue(mockPresenter.list.count == viewController.deliveryList.count)
    }

    func testFetchDataWhenNewDataAvailable() {
        mockPresenter.dataNA = false
        let deliveryList = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE),TestUtility.mockInfo(TestConstants.FAKE_ID_TWO),TestUtility.mockInfo(TestConstants.FAKE_ID_THREE)]
        viewController.deliveryList = deliveryList
        mockPresenter.list = viewController.deliveryList
        viewController.presenter?.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, false)
        XCTAssertTrue(viewController.deliveryList.count > mockPresenter.list.count)
    }

    func testFetchDataWhenNewDataAvailableAndRefreshed() {
        mockPresenter.dataNA = false
        mockPresenter.refreshData = true
        let deliveryList = [TestUtility.mockInfo(TestConstants.FAKE_ID_ONE),TestUtility.mockInfo(TestConstants.FAKE_ID_TWO),TestUtility.mockInfo(TestConstants.FAKE_ID_THREE)]
        viewController.deliveryList = deliveryList
        mockPresenter.list = viewController.deliveryList
        viewController.presenter?.fetchDeliveryList(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT, true)
        XCTAssertTrue(viewController.deliveryList.count <= mockPresenter.list.count)
    }
    
    func testShowOfflineView() {
        viewController.showOfflineView()
        XCTAssertTrue((viewController.message.text != nil),Constants.OFFLINE_MESSAGE)
    }

    func testRemoveOfflineView() {
        viewController.removeOfflineView()
        XCTAssert(viewController.message.text == nil)
    }
    
    func testStartSpinner() {
        viewController.startSpinner()
        XCTAssertTrue(viewController.spinner.isAnimating == true)
    }
    
    func testStopSpinner() {
        viewController.stopSpinner()
        XCTAssertTrue(viewController.spinner.isAnimating == false)
    }

    func testStopPullToRefresh() {
        viewController.stopPullToRefresh()
        XCTAssertTrue(viewController.refreshControl.isRefreshing == false)
    }

    func testStartPullToRefresh() {
        viewController.startPullToRefresh()
        XCTAssertTrue(viewController.refreshControl.isRefreshing == true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
