//
//  CreateTaskViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class CreateTaskViewController: UIViewController {

    // MARK: Interface Outlets
    @IBOutlet weak var taskNameTextView: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskDueDatePicker: UIDatePicker!
    @IBOutlet weak var taskSendReminderButton: UIButton!
    @IBOutlet weak var taskResponseProgressLabel: UILabel!
    
    
    // MARK: other variables
    var task: Task?
    
    
    // MARK: lifecycle
    override func viewDidLoad() {
        if let unwrappedTask = task {
            self.taskNameTextView.text = unwrappedTask.Name
            self.taskDescriptionTextView.text = unwrappedTask.Description
            self.taskDueDatePicker.date = unwrappedTask.DueDate
            self.taskResponseProgressLabel.hidden = false
            self.taskResponseProgressLabel.text = "\(unwrappedTask.NumUsersCompleted)/\(unwrappedTask.MemberTaskStatuses.count) Responded"
            if unwrappedTask.NumUsersCompleted != unwrappedTask.MemberTaskStatuses.count {
                self.taskSendReminderButton.hidden = false
            }
        }
        super.viewDidLoad()
    }
    
}