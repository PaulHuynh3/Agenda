//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Paul on 2019-05-05.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var contentDescription: String?

}
