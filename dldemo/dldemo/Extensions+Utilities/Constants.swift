//
//  Constants.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lalamove. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static let FETCH_LIMIT:Int = 20
    static let INTIAL_OFFSET_VALUE:Int = 0
    static let DELIVERY_LIST_TITLE = "Delivery List"
    static let DELIVERY_LOCATION_TITLE = "Delivery Location"
    static let ROW_HEIGHT:CGFloat = 100
    static let ALERT_TITLE:String = "ERROR!"
    static let GOOGLE_MAPS_KEY = "AIzaSyBi1ex8GU9LTWhvQ_O6-kclVYCNZX0yvbc"
    static let CORNER_RADIUS:CGFloat = 10
    static let NUMBER_OF_LINES:Int = 0
    static let DESCRIPTION_SEPARATOR = " at "
    static let PLACEHOLDER_IMAGE = "ProfilePlaceholder"
    static let OFFLINE_MESSAGE = "Network is offline, Please connect device to internet"
    static let DELIVERY_LIST_CD_ENTITY_NAME = "DeliveryListCD"
    static let LOCATION_CD_ENTITY_NAME = "LocationCD"
    static let IMAGE_SIZE = CGSize(width: 80, height: 80)
    static let BANNER_DURATION = 2.0
    static let PREDICATE_ID_KEY = "id"
    static let OFFSET = "offset"
    static let LIMIT = "limit"
}

enum Cells {
    static let deliveryCell = "DeliveryCell"
}

enum APIService {
    static let DELIVERY_LIST:String = "https://mock-api-mobile.dev.lalamove.com/deliveries"
}

enum AppError: Error {
    case networkError
    case decodingError
    case emptyDataError
    case offlineError
    case coreDataError
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError:
            return NSLocalizedString("Network error occured, please try again", comment: "")
        case .decodingError:
            return NSLocalizedString("Unable to decode", comment: "")
        case .emptyDataError:
            return NSLocalizedString("No more data available", comment: "")
        case .offlineError:
            return NSLocalizedString("Network is offline, Please connect device to internet", comment: "")
        case .coreDataError:
            return NSLocalizedString("Fetching error due to unknown reason", comment: "")
        }
    }
}



