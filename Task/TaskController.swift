//
//  TaskController.swift
//  Task
//
//  Created by Uldis Zingis on 05/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

class TaskController {
    static let sharedController = TaskController()
    
    var fetchedResultsController: NSFetchedResultsController<Task>
    
    init() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "isComplete", ascending: true), NSSortDescriptor(key: "due", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                managedObjectContext: CoreDataStack.context,
                                                sectionNameKeyPath: "isComplete",
                                                cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Error preforming fetch: \(error)")
        }
    }
    
    func createTask(name: String, notes: String?, due: Date?, isComplete: Bool?) -> Task {
        let task = Task(name: name, notes: nil, due: nil, isComplete: nil, context: CoreDataStack.context)
        if let notes = notes { task.notes = notes }
        if let due = due { task.due = due as NSDate }
        if let isComplete = isComplete { task.isComplete = isComplete }
        
        scheduleNotification(task: task)
        return task
    }
    
    func update(task: Task, name: String?, notes: String?, due: Date?) {
        if let name = name { task.name = name }
        if let notes = notes { task.notes = notes }
        if let due = due {
            task.due = due as NSDate
            cancelNotification(task: task)
            scheduleNotification(task: task)
        }
    }
    
    func updateCompleteness(task: Task) {
        task.isComplete = !task.isComplete
        if task.isComplete {
            cancelNotification(task: task)
        } else {
            scheduleNotification(task: task)
        }
    }
    
    func remove(task: Task) {
        task.managedObjectContext?.delete(task)
        cancelNotification(task: task)
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            NSLog("Error while saving core data: \(error.localizedDescription)")
        }
    }
    
    func scheduleNotification(task: Task) {
        // 1. Make notification content
        // 2. Make  a trigger (and identifier)
        // 3. Make a notification request
        // 4. Add the request to the app
        guard let name = task.name, let date = task.due as? Date else { return }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = name
        if let notes = task.notes {
            notificationContent.body = String(notes.characters.prefix(20))
        }
        
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(identifier: task.id!, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func cancelNotification(task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id!])
    }
}
