//
//  TaskStatusTableViewCell.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol TaskStatusTableViewCellDelegate {
    func taskStatusCellSendReminderTapped(taskStatusTableViewCell: TaskStatusTableViewCell)
}

class TaskStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDueDateLabel: UILabel!
    @IBOutlet weak var taskSendReminderButton: UIButton!
    @IBAction func taskSendReminderButtonTapped(sender: AnyObject) {
        self.delegate?.taskStatusCellSendReminderTapped(self)
    }
    
    static let reuseIdentifier = "TaskStatusTableViewCell"
    
    var delegate: TaskStatusTableViewCellDelegate?
}