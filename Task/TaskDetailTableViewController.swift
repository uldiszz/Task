//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Uldis Zingis on 05/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {

    @IBOutlet weak var nameTextLabel: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextLabel: UITextView!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWith()
    }
    
    func updateWith() {
        guard let task = task else { return }
        nameTextLabel.text = task.name
        notesTextLabel.text = task.notes
        if let due = task.due {
            dueDatePicker.date = due as Date
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        if let taskName = nameTextLabel.text, taskName != "" {
            if let task = task {
                TaskController.sharedController.update(task: task, name: taskName, notes: notesTextLabel.text, due: dueDatePicker.date)
            } else {
                let _ = TaskController.sharedController.createTask(name: taskName, notes: notesTextLabel.text, due: dueDatePicker.date, isComplete: false)
            }
            let _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func userTappedView(_ sender: AnyObject) {
        view.endEditing(true)
    }
}
