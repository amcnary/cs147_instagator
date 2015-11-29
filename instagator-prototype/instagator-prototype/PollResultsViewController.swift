//
//  PollResultsViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class PollResultsViewController: UIViewController {
    // MARK: Interface Outlets
    @IBOutlet weak var pollResultsTitleLabel: UILabel!
    @IBOutlet weak var pollResponseProgressLabel: UILabel!
    @IBOutlet weak var pollSendReminderButton: UIButton!
    @IBOutlet weak var pollTopActivityNameLabel: UILabel!
    @IBOutlet weak var pollTopActivityDatesLabel: UILabel!
    @IBOutlet weak var pollTopActivityProjectedCostLabel: UILabel!
    @IBOutlet weak var pollTopActivityDescriptionLabel: UILabel!
    @IBOutlet weak var pollSelectTopActivityButton: UIButton!
    @IBOutlet weak var pollDetailedResultsTableView: UITableView!
    
}