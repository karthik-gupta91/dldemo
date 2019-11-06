//
//  DeliveryListCD+CoreDataClass.swift
//  
//
//  Created by kartik on 29/10/19.
//
//

import Foundation
import CoreData

protocol InteractorToCDProtocol: class {
    func fetchDeliveryListFromCD(_ offset:Int,_ limit:Int, completion:(_ deliveryInfo:[DeliveryInfo]?,_ error:Error?) -> (Void))
    func saveUpdateDeliveryListfromCD(_ list:[DeliveryInfo])
}

@objc(DeliveryListCD)
public class DeliveryListCD: NSManagedObject,InteractorToCDProtocol {
    
    var stack: CoreDataStack!
    
    convenience init(with stack:CoreDataStack) {
        let context = stack.managedObjectContext()
        let entity = NSEntityDescription.entity(forEntityName: Constants.DELIVERY_LIST_CD_ENTITY_NAME, in: context)
        self.init(entity: entity!, insertInto: context)
        self.stack = stack
    }
    
    func fetchDeliveryListFromCD( _ offset: Int, _ limit: Int, completion:([DeliveryInfo]?, Error?) -> (Void)) {
        let context = stack.managedObjectContext()
        var deliveryList: [DeliveryInfo] = []
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DELIVERY_LIST_CD_ENTITY_NAME)
            request.fetchOffset = offset
            request.fetchLimit = limit
            let fetchedResults = try context.fetch(request)
            for result in fetchedResults as! [DeliveryListCD] {
                let deliveryInfo = DeliveryInfo(from: result)
                deliveryList.append(deliveryInfo)
            }
            completion(deliveryList,nil)
        } catch {
            completion(nil,error)
        }
    }
    
    func saveUpdateDeliveryListfromCD(_ list:[DeliveryInfo]) {
        let context = stack.managedObjectContext()
        for i in 0..<list.count {
            saveUpdateDelivery(list[i], in: context)
        }
        saveContext(context)
    }
    
    private func saveUpdateDelivery(_ deliveryInfo:DeliveryInfo,in context:NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.DELIVERY_LIST_CD_ENTITY_NAME)
        request.predicate = NSPredicate(format: "\(Constants.PREDICATE_ID_KEY) = \(deliveryInfo.id)")
        do {
            let cdDelivery = try context.fetch(request)
            if let cdDeliveryInfo = cdDelivery.first as? DeliveryListCD {
                updateDeliveryInfo(deliveryInfo: deliveryInfo, to: cdDeliveryInfo, in: context)
            } else {
                saveDeliveryInfo(deliveryInfo: deliveryInfo, in: context)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func saveDeliveryInfo(deliveryInfo:DeliveryInfo,in context:NSManagedObjectContext) {
        let entity =  NSEntityDescription.entity(forEntityName: Constants.DELIVERY_LIST_CD_ENTITY_NAME, in:context)
        if let item = NSManagedObject(entity: entity!, insertInto:context) as? DeliveryListCD {
            item.desc = deliveryInfo.description
            item.id = Int16(deliveryInfo.id)
            item.imageUrl = deliveryInfo.imageUrl
            let locEntity = NSEntityDescription.entity(forEntityName: Constants.LOCATION_CD_ENTITY_NAME, in: context)
            if let location = NSManagedObject(entity: locEntity!, insertInto: context) as? LocationCD {
                location.lng = deliveryInfo.location.lng
                location.lat = deliveryInfo.location.lat
                location.address = deliveryInfo.location.address
                item.location = location
            }
        }
    }
    
    private func updateDeliveryInfo(deliveryInfo:DeliveryInfo,to cdDeliveryInfo:DeliveryListCD,in context:NSManagedObjectContext) {
        cdDeliveryInfo.desc = deliveryInfo.description
        cdDeliveryInfo.id = Int16(deliveryInfo.id)
        cdDeliveryInfo.imageUrl = deliveryInfo.imageUrl
        let locEntity = NSEntityDescription.entity(forEntityName: Constants.LOCATION_CD_ENTITY_NAME, in: context)
        if let location = NSManagedObject(entity: locEntity!, insertInto: context) as? LocationCD {
            location.lng = deliveryInfo.location.lng
            location.lat = deliveryInfo.location.lat
            location.address = deliveryInfo.location.address
            cdDeliveryInfo.location = location
        }
    }
    
    private func saveContext(_ context:NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
