//
//  DeliveryModel.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lalamove. All rights reserved.
//

import Foundation
import UIKit

struct DeliveryInfo: Codable {
    var id: Int
    var imageUrl: String
    var description: String
    var location: Location
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl
        case description
        case location
    }
    
    init(from id:Int, imageURl:String, desc:String, lat:Double, lng:Double, address:String) {
        self.id = id
        self.imageUrl = imageURl
        self.description = desc
        self.location = Location(from: lat, lng: lng, address: address)
    }
    
    init(from deliveryInfo:DeliveryListCD) {
        self.id = Int(deliveryInfo.id)
        self.imageUrl = deliveryInfo.imageUrl!
        self.description = deliveryInfo.desc!
        self.location = Location(from: deliveryInfo.location!)
    }
    
    init(from decoder:Decoder) throws {
        self.id = try decoder.container(keyedBy: CodingKeys.self).decode(Int.self, forKey: .id)
        self.imageUrl = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .imageUrl)
        self.description = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .description)
        self.location = try decoder.container(keyedBy: CodingKeys.self).decode(Location.self, forKey: .location)
    }
}


