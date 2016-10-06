//
//  Task+Consistence.swift
//  Task
//
//  Created by Uldis Zingis on 05/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    convenience init(name: String,
                 notes: String?,
                 due: Date?,
                 isComplete: Bool?,
                 context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.due = due as NSDate?
        self.id = String(describing: UUID())
        if let isComplete = isComplete {
            self.isComplete = isComplete
        } else {
            self.isComplete = false
        }
    }
}
