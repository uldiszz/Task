//
//  TaskListTableViewController.swift
//  Task
//
//  Created by Uldis Zingis on 05/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, ButtonTableViewCellDelegate, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        TaskController.sharedController.fetchedResultsController.delegate = self
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskController.sharedController.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionValue = TaskController.sharedController.fetchedResultsController.sections?[section].name
        let title = sectionValue == "1" ? "Complete" : "Incomplete"
        
        return title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = TaskController.sharedController.fetchedResultsController.sections else { return 0 }
        
        let section = sections[section]
        
        return section.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? ButtonTableViewCell else { return UITableViewCell() }

        let fetchedController = TaskController.sharedController.fetchedResultsController
        let task = fetchedController.object(at: indexPath)
        
        cell.delegate = self
        cell.updateWithTask(task: task)

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fetchedController = TaskController.sharedController.fetchedResultsController
            let task = fetchedController.object(at: indexPath)
            TaskController.sharedController.remove(task: task)
        }
    }
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        
        let fetchedController = TaskController.sharedController.fetchedResultsController
        let task = fetchedController.object(at: indexPath)
        TaskController.sharedController.updateCompleteness(task: task)
        tableView.reloadData()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
//            tableView.moveRow(at: indexPath, to: newIndexPath) // <------ THIS FUNCTION DOES NOT WORK (CRASHED THE APP) !!!
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
//            tableView.reloadRows(at: [indexPath], with: .fade) // <------ THIS FUNCTION DOES NOT WORK (CRASHED THE APP) !!!
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }

    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections([sectionIndex], with: .bottom)
        case .insert:
            tableView.insertSections([sectionIndex], with: .top)
        default:
            break
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExistingTask" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let fetchedController = TaskController.sharedController.fetchedResultsController
            let task = fetchedController.object(at: indexPath)
            
            if let nextVC = segue.destination as? TaskDetailTableViewController {
                nextVC.task = task
            }
        }
    }
}
