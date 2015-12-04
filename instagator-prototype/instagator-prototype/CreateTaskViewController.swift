//
//  CreateTaskViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol CreateTaskViewControllerDelegate {
    func createTaskControllerSaveTapped(createTaskViewController: CreateTaskViewController, savedTask task: Task)
}

class CreateTaskViewController: UIViewController {

    // MARK: Interface Outlets
    @IBOutlet weak var taskNameTextView: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskDueDatePicker: UIDatePicker!
    @IBOutlet weak var taskResponseProgressLabel: UILabel!
    @IBOutlet weak var navigationBarItem: UINavigationItem!

    @IBOutlet weak var taskSendReminderButton: UIButton!
    @IBAction func taskSendReminderButtonTapped(sender: AnyObject) {
        self.presentConfirmationMessage("Reminder Sent!")
    }
    
    // MARK: other variables
    var task: Task?
    var trip: Trip?
    var delegate: CreateTaskViewControllerDelegate?
    var tripOwnershipType: TripListViewController.TripOwnershipType = .Planning
    
    
    // MARK: lifecycle

    override func viewDidLoad() {
        if let unwrappedTask = task {
            self.taskNameTextView.text = unwrappedTask.Name
            self.taskDescriptionTextView.text = unwrappedTask.Description
            self.taskDueDatePicker.date = unwrappedTask.DueDate
            
            if self.tripOwnershipType == .Attending {
                self.navigationBarItem.rightBarButtonItems = nil
                self.taskDescriptionTextView.userInteractionEnabled = false
                self.taskDueDatePicker.userInteractionEnabled = false
                self.taskNameTextView.userInteractionEnabled = false
            } else {
                self.taskResponseProgressLabel.hidden = false
                self.taskResponseProgressLabel.text = "\(unwrappedTask.NumUsersCompleted)/\(unwrappedTask.MemberTaskStatuses.count) Responded"
                if unwrappedTask.NumUsersCompleted != unwrappedTask.MemberTaskStatuses.count {
                    self.taskSendReminderButton.hidden = false
                }
            }
        }
        super.viewDidLoad()
    }
    
    @IBAction func taskSaveButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Form Error", message: "", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alertController.addAction(confirmAction)
        
        guard let taskName = self.taskNameTextView.text where taskName != "Task Name" && taskName != "" else {
            alertController.message = "You must include a task name!"
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let taskDescription = (self.taskDescriptionTextView.text != "Task Description (optional)") ? self.taskDescriptionTextView.text : ""
        let taskDueDate = self.taskDueDatePicker.date
        var taskStatuses: [Person: Task.Status] = [:]
        if let unwrappedTrip = self.trip {
            for member in unwrappedTrip.Members {
                taskStatuses[member.0] = .Incomplete
            }
        }
        
        let taskToReturn: Task = Task(name: taskName, description: taskDescription, dueDate: taskDueDate, memberTaskStatuses: taskStatuses)
        if self.task != nil {
            let taskChangeAlertController = UIAlertController(title: "Warning",
                message: "Changing this task will force all users to redo this task. Continue?", preferredStyle: .Alert)
            let continueAction = UIAlertAction(title: "Continue", style: .Default, handler: { _ in
                self.delegate?.createTaskControllerSaveTapped(self, savedTask: taskToReturn)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            taskChangeAlertController.addAction(cancelAction)
            taskChangeAlertController.addAction(continueAction)
            self.presentViewController(taskChangeAlertController, animated: true, completion: nil)
        }
    }
}