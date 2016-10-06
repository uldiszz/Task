//
//  TaskController.swift
//  Task
//
//  Created by Uldis Zingis on 05/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    static let sharedController = TaskController()
    
    var tasks: [Task] {
        return self.fetchTasks()
    }
    
    var mockTasks: [Task] {
        let taskOne = createTask(name: "Today's task", notes: "Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.", due: Date(), isComplete: nil)
        let taskTwo = createTask(name: "Tomorrow's task", notes: "Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.", due: Date().addingTimeInterval(86400), isComplete: nil) // Added 86400 seconds (it is 1 day) so this task's due date is tomorrow
        let taskThree = createTask(name: "Done task", notes: "Nullam id dolor id.", due: nil, isComplete: true)
        
        return [taskOne, taskTwo, taskThree]
    }
    
    var completedTasks: [Task] {
        return tasks.filter {$0.isComplete == true}
    }
    var incompleteTasks: [Task] {
        return tasks.filter {$0.isComplete == false}
    }
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            let tasks = try CoreDataStack.container.viewContext.fetch(request)
            return tasks
        } catch {
            NSLog("Error while fetching tasks from code data: \(error.localizedDescription)")
            return []
        }
    }
    
    func createTask(name: String, notes: String?, due: Date?, isComplete: Bool?) -> Task {
        let task = Task(name: name, notes: nil, due: nil, isComplete: nil, context: CoreDataStack.context)
        if let notes = notes { task.notes = notes }
        if let due = due { task.due = due as NSDate }
        if let isComplete = isComplete { task.isComplete = isComplete }
        save()
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
        save()
    }
    
    func updateCompleteness(task: Task) {
        task.isComplete = !task.isComplete
        if task.isComplete {
            cancelNotification(task: task)
        } else {
            scheduleNotification(task: task)
        }
        save()
    }
    
    func remove(task: Task) {
        task.managedObjectContext?.delete(task)
        cancelNotification(task: task)
        save()
    }
    
    func save() {
        do {
            try CoreDataStack.context.save()
        } catch {
            NSLog("Error while saving core data: \(error.localizedDescription)")
        }
    }
    
    func scheduleNotification(task: Task) {
        
    }
    
    func cancelNotification(task: Task) {
        
    }
}
