//
//  MockCoreDataStack.swift
//  dldemoTests
//
//  Created by kartik on 31/10/19.
//  Copyright © 2019 nof2f. All rights reserved.
//

import Foundation
import CoreData
@testable import dldemo

class MockCoreDataStack: CoreDataStack {
    
    override func managedObjectContext() -> NSManagedObjectContext {
        return managedObjectContextFake
    }
    
    lazy var managedObjectContextFake: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinatorFake
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var persistentStoreCoordinatorFake: NSPersistentStoreCoordinator? = {
        guard let model = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            fatalError("Could not create model")
        }
        
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        do {
            try coordinator!.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        }
        catch {
            coordinator = nil
            print("Error")
        }

        return coordinator
    }()
    
}
