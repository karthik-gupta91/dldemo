//
//  DeliveryListCDTests.swift
//  dldemoTests
//
//  Created by kartik on 30/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import XCTest
import CoreData
@testable import dldemo

class DeliveryListCoredataTests: XCTestCase {

    var deliveryListCD: DeliveryListCD!
    
    override func setUp() {
        deliveryListCD = DeliveryListCD()
        deliveryListCD.stack = MockCoreDataStack()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFromCDWhenOfflineCacheNil() {
        var dlList: [DeliveryInfo]!
        
        deliveryListCD.fetchDeliveryListFromCD(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT) { (list, error) -> Void in
            dlList = list
        }
        
        XCTAssertTrue(dlList.isEmpty)
    }

    func testFromCDWhenOfflineCachePresent() {
        var dlList: [DeliveryInfo]!
        deliveryListCD.saveUpdateDeliveryListfromCD([TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)])
        
        deliveryListCD.fetchDeliveryListFromCD(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT) { (list, error) -> Void in
            dlList = list
        }

        XCTAssertTrue(!dlList.isEmpty)
    }
    
    func testFromCDWhenOfflineCachePresentUpdateAndFetch() {
        var dlList: [DeliveryInfo]!
        
        var deliveryInfo = TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)
        deliveryListCD.saveUpdateDeliveryListfromCD([deliveryInfo])
        
        deliveryInfo = TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)
        deliveryListCD.saveUpdateDeliveryListfromCD([deliveryInfo])
        
        deliveryListCD.fetchDeliveryListFromCD(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT) { (list, error) -> Void in
            dlList = list
        }
        
        XCTAssertTrue(dlList.count == 1)
    }
    
    func testFromCDWhenOnlineResultMoreThanOfflineCacheWithSameId() {
        var dlList: [DeliveryInfo]!
        
        let deliveryInfo = TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)
        deliveryListCD.saveUpdateDeliveryListfromCD([deliveryInfo])
        
        let deliveryInfo1 = TestUtility.mockInfo(TestConstants.FAKE_ID_ONE)
        let deliveryInfo2 = TestUtility.mockInfo(TestConstants.FAKE_ID_THREE)
        let deliveryList = [deliveryInfo1,deliveryInfo2]
        deliveryListCD.saveUpdateDeliveryListfromCD(deliveryList)
        
        deliveryListCD.fetchDeliveryListFromCD(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT) { (list, error) -> Void in
            dlList = list
        }
        
        XCTAssertTrue(dlList.count == 2)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
