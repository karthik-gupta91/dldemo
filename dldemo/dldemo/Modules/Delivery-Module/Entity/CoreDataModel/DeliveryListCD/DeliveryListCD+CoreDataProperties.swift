//
//  DeliveryListCD+CoreDataProperties.swift
//  
//
//  Created by kartik on 29/10/19.
//
//

import Foundation
import CoreData


extension DeliveryListCD {
    
    @NSManaged public var desc: String?
    @NSManaged public var id: Int16
    @NSManaged public var imageUrl: String?
    @NSManaged public var location: LocationCD?

}
