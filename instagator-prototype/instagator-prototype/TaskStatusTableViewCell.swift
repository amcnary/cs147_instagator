//
//  TaskStatusTableViewCell.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class TaskStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDueDateLabel: UILabel!
    @IBOutlet weak var taskSendReminderButton: UIButton!
    @IBAction func taskSendReminderButtonTapped(sender: AnyObject) {
        
    }
    
    static let reuseIdentifier = "TaskStatusTableViewCell"
    
    
}