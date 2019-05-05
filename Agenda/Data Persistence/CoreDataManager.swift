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
    
    static var sharedInstance = CoreDataManager()
    
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
        let managedObjectContext = persistentContainer.viewContext
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasksBy(title: String) -> [Task] {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        guard let tasks = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            fatalError("Task: \(title) does not exist")
        }
        return tasks
    }
    
    func sortTasksBy(title: String) -> [Task] {
        let fetchRequest = Task.fetchRequest() as NSFetchRequest<Task>
        let sort = NSSortDescriptor(keyPath: \Task.title, ascending: true)
        fetchRequest.sortDescriptors = [sort]
        guard let tasks = try? persistentContainer.viewContext.fetch(fetchRequest) else {
            fatalError("Issue sorting by: \(title)")
        }
        return tasks
    }
    
}
