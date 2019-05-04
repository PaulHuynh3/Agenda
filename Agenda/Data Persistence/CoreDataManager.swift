//
//  CoreDataSync.swift
//  Agenda
//
//  Created by Paul on 2019-05-04.
//  Copyright © 2019 PaulsWork. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Agenda")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print(storeDescription)
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
    
    
//    func addTestData() {
//        let managedObjectContext = persistentContainer.viewContext
//
//        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: ) else {
//            fatalError("Could not find Task entity description")
//        }
//    }
