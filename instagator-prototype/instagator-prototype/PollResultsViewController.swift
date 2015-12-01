//
//  PollResultsViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class PollResultsViewController: UIViewController, UITableViewDataSource {
    
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
    
    
    // MARK: other properties
    
    var poll: Poll?
    
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        if let unwrappedPoll = poll {
            let winningOption = unwrappedPoll.Options[1]
            self.pollResultsTitleLabel.text = unwrappedPoll.Name
            self.pollResponseProgressLabel.text = "2/4 Responded"
            self.pollTopActivityNameLabel.text = winningOption.Name
            self.pollTopActivityDescriptionLabel.text = winningOption.Description
            let startTime = dateTimeFormatter.stringFromDate(winningOption.StartDate)
            let endTime = dateTimeFormatter.stringFromDate(winningOption.EndDate)
            self.pollTopActivityDatesLabel.text = "\(startTime) to \(endTime)"
            if let projectedCost = winningOption.Cost {
                self.pollTopActivityProjectedCostLabel.text = "$\(projectedCost)"
            }
        }
    }
    
    // MARK: UITableViewDataSource protocol methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: dequeue the cell we want, fill its subviews, and return it
        if let unwrappedPoll = poll, cell = tableView.dequeueReusableCellWithIdentifier(PollActivityResultTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PollActivityResultTableViewCell {
            let currentOption = unwrappedPoll.Options[indexPath.row]
            cell.activityNameLabel.text = currentOption.Name
            cell.activitySatisfactionLabel.text = "Satisfaction: \(unwrappedPoll.Results[indexPath.row])%"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll?.Options.count ?? 0
    }

}