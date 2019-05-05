//
//  ViewController.swift
//  Agenda
//
//  Created by Paul on 2019-05-04.
//  Copyright © 2019 PaulsWork. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    private var coreDataManager: CoreDataManager
    private let context: NSManagedObjectContext
    private var tasks: [Task]
    
    required init?(coder aDecoder: NSCoder) {
        coreDataManager = CoreDataManager()
        context = coreDataManager.persistentContainer.viewContext
        tasks = [Task]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let tasks = coreDataManager.fetchTasksBy(title: "First Task")
        for task in tasks {
          print(task)
        }
    }

    private func persistTask() {
        let task = Task(entity: Task.entity(), insertInto: context)
        task.title = "Third Task"
        task.content = "This one has content"
        task.isComplete = false
        task.deadline = NSDate(timeIntervalSinceNow: TimeInterval(exactly: 2.0)!)
        coreDataManager.saveContext()
        tasks.append(task)
    }

}

