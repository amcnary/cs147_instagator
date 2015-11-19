//
//  TaskTableViewCell.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/18/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class TaskTableViewCell: UITableViewCell {

    // MARK: constants
    
    static let reuseIdentifier = "TaskTableViewCell"
    
    
    // MARK: - interface outlets
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskDeadlineLabel: UILabel!
    @IBOutlet weak var taskInviteeProgressLabel: UILabel!
    
}