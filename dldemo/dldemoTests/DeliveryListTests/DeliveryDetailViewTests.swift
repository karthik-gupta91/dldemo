//
//  DeliveryDetailTestView.swift
//  dldemoTests
//
//  Created by kartik on 06/11/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import XCTest
@testable import dldemo

class DeliveryDetailViewTests: XCTestCase {

    var viewController: DeliveryDetailVC!
    
    override func setUp() {
        viewController = DeliveryDetailVC(from: TestUtility.mockInfo(TestConstants.FAKE_ID_ONE))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDidLoad() {
        viewController.viewDidLoad()
        XCTAssertEqual(viewController.title?.description, Constants.DELIVERY_LOCATION_TITLE)
        XCTAssertTrue(viewController.deliveryInfo != nil)
        XCTAssertEqual(viewController.descLabel.text,viewController.deliveryInfo.description + Constants.DESCRIPTION_SEPARATOR + viewController.deliveryInfo.location.address)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
