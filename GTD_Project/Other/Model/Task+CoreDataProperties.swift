//
//  Task+CoreDataProperties.swift
//  GTD_Project
//
//  Created by MacBook on 24/12/2018.
//  Copyright © 2018 PB. All rights reserved.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var category: NSObject?
    @NSManaged public var dateInfo: String?
    @NSManaged public var executor: String?
    @NSManaged public var project: NSObject?
    @NSManaged public var reminder: NSDate?
    @NSManaged public var result: String?
    @NSManaged public var taskDate: NSDate?
    @NSManaged public var title: String?

}
