//
//  Task.swift
//  CoreDataEx2
//
//  Created by Omar Albeik on 12/10/15.
//  Copyright © 2015 Omar Albeik. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var desc: String?
    @NSManaged var date: NSDate
    @NSManaged var completed: NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(title: String, desc: String?, date: NSDate, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.desc = desc
        self.date = date
        self.completed = true
    }
    
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Task", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}
