//
//  TestsConstants.swift
//  dldemoTests
//
//  Created by kartik on 31/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import Foundation
import UIKit
@testable import dldemo

enum TestConstants {
    
    static let DELIVERY_LIST_KEY = "showDeliveryList"
    static let FETCH_DELIVERY_LIST_VALUE = "Delivery List Fetched"
    static let REFRESH_DELIVERY_LIST_VALUE = "Delivery List Refreshed"
    static let RECIEVED_DELIVERY_LIST_VALUE = "Delivery List Received"
    static let ERROR_KEY = "showError"
    static let SHOW_DETAIL_VC_KEY = "showDetailVC"
    static let SHOW_DETAIL_VC_VALUE = "Detail Screen Poped"
    static let NETWORK_UNAVAILABLE = "Network Unavailable"
    static let NETWORK_AVAILABLE = "Network Available"
    static let START_PULL_REFRESH_VALUE = "Start pull to refresh Called"
    static let START_PULL_REFRESH_KEY = "StartPull"
    static let STOP_PULL_REFRESH_VALUE = "Stop pull to refresh Called"
    static let STOP_PULL_REFRESH_KEY = "StopPull"
    static let START_SPINNER_KEY = "startSpinner"
    static let START_SPINNER_VALUE = "Start spinner called"
    static let STOP_SPINNER_KEY = "stopSpinner"
    static let STOP_SPINNER_VALUE = "Stop spinner called"
    static let SHOW_OFFLINE_VIEW_KEY = "showOfflineView"
    static let SHOW_OFFLINE_VIEW_VALUE = "Show offline view called"
    static let REMOVE_OFFLINE_VIEW_KEY = "removeOfflineView"
    static let REMOVE_OFFLINE_VIEW_VALUE = "Remove offline view called"
    static let SAVE_UPDATE_DL_KEY = "saveUpdateDL"
    static let SAVE_UPDATE_DL_VALUE = "SaveUpdate DL in CoreData Called"

    static let FAKE_ID_ONE:Int = -1000
    static let FAKE_ID_TWO:Int = -1001
    static let FAKE_ID_THREE:Int = -1002

}

struct TestUtility {
    static func mockInfo(_ id:Int) -> DeliveryInfo {
        return DeliveryInfo(from: id, imageURl: "https://s3-ap-southeast-1.amazonaws.com/lalamove-mock-api/images/pet-1.jpeg", desc: "Deliver wine to Kenneth", lat: 22.335538, lng: 114.176169, address: "Kowloon Tong")
    }
}

