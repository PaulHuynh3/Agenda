//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Paul on 2019-05-04.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var deadline: NSDate?
    @NSManaged public var isComplete: Bool
    @NSManaged public var title: String?
    @NSManaged public var content: String?

}
