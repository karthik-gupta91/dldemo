//
//  CoreDataStack.swift
//  dldemo
//
//  Created by kartik on 29/10/19.
//  Copyright © 2019 lamo. All rights reserved.
//

import Foundation
import CoreData

private let RESOURCE_NAME = "dldemo"
private let EXTENSION = "momd"
private let SQLITE_DIRECTORY_NAME = "dldemo.sqlite"

class CoreDataStack {

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: RESOURCE_NAME, withExtension: EXTENSION)!
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let applicationDocumentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        let persistentStoreUrl: URL = applicationDocumentsDirectory.appendingPathComponent(SQLITE_DIRECTORY_NAME)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreUrl, options: nil)
        }
        catch {
            fatalError("Persistent store error! \(error)")
        }
        
        return coordinator
    }()
    
    func managedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }
    
}
