//
//  LocationCD+CoreDataProperties.swift
//  
//
//  Created by kartik on 29/10/19.
//
//

import Foundation
import CoreData


extension LocationCD {

    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var address: String?
    @NSManaged public var deliveryInfo: DeliveryListCD?

}
