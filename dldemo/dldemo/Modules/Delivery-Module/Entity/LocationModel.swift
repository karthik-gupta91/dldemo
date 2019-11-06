//
//  LocationModel.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation
import UIKit

struct Location: Codable {
    
    var lat:Double
    var lng: Double
    var address: String
    
    init(from lat:Double, lng:Double, address:String) {
        self.lat = lat
        self.lng = lng
        self.address = address
    }
    
    init(from locationCD:LocationCD) {
        self.lat = locationCD.lat
        self.lng = locationCD.lng
        self.address = locationCD.address!
    }
}
