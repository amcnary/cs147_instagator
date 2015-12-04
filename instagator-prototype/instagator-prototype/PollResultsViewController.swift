//
//  PollResultsViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol PollResultsViewControllerDelegate {
    func pollResultsViewController(pollResultsViewController: PollResultsViewController, selectAndSaveButtonTappedForEvent event: Event)
}

class PollResultsViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Interface Outlets
    
    @IBAction func pollResultInfoButtonTapped(sender: AnyObject) {
        self.presentConfirmationMessage("Satisfaction rates are calculated by weighting the preferences of the different options from each poll response. First place votes are given the most weight, followed by second place, and so on.")
    }
    @IBOutlet weak var pollResultsTitleLabel: UILabel!
    @IBOutlet weak var pollResponseProgressLabel: UILabel!
    @IBOutlet weak var pollSendReminderButton: UIButton!
    @IBOutlet weak var pollTopActivityNameLabel: UILabel!
    @IBOutlet weak var pollTopActivityDatesLabel: UILabel!
    @IBOutlet weak var pollTopActivityProjectedCostLabel: UILabel!
    @IBOutlet weak var pollTopActivityDescriptionLabel: UILabel!
    @IBOutlet weak var pollDetailedResultsTableView: UITableView!
    @IBOutlet weak var pollSelectAndCloseButton: UIButton!
    @IBAction func pollSelectAndCloseButtonTapped(sender: AnyObject) {
        // send winning event back to delegate
        // dismiss this page forever
        // change the activity from the poll to the winning event
        if let unwrappedPoll = self.poll {
            self.delegate?.pollResultsViewController(self, selectAndSaveButtonTappedForEvent: unwrappedPoll.Options[0])
        }
    }
    @IBAction func deletePollButtonTapped(sender: AnyObject) {
    }
    @IBAction func sendVoteReminderTapped(sender: AnyObject) {
        self.presentConfirmationMessage("Reminder sent!")
    }
    
    
    // MARK: other properties
    var poll: Poll?
    var delegate: PollResultsViewControllerDelegate?
    
    
    // MARK: lifecycle

    override func viewDidLoad() {
        if let unwrappedPoll = poll {
            
            self.pollResultsTitleLabel.text = unwrappedPoll.Name
            self.pollResponseProgressLabel.text = "\(unwrappedPoll.NumPeopleResponded)/\(unwrappedPoll.People.count) Responded"
            
            if unwrappedPoll.NumPeopleResponded != 0 {
                let winningOption = unwrappedPoll.Options[0]
                self.pollTopActivityNameLabel.text = winningOption.Name
                self.pollTopActivityDescriptionLabel.text = winningOption.Description
                let startTime = dateTimeFormatter.stringFromDate(winningOption.StartDate)
                let endTime = dateTimeFormatter.stringFromDate(winningOption.EndDate)
                self.pollTopActivityDatesLabel.text = "\(startTime) to \(endTime)"
                if let projectedCost = winningOption.Cost {
                    self.pollTopActivityProjectedCostLabel.text = "$\(projectedCost)0"
                }
            } else if unwrappedPoll.NumPeopleResponded == unwrappedPoll.People.count {
                self.pollSendReminderButton.hidden = true
            } else {
                self.pollTopActivityNameLabel.text = "No winner yet. Lowest-cost approach?"
                self.pollTopActivityDatesLabel.hidden = true
                self.pollTopActivityProjectedCostLabel.hidden = true
                self.pollTopActivityDescriptionLabel.hidden = true
                self.pollSelectAndCloseButton.hidden = true
            }
        }
        super.viewDidLoad()
    }
    
    // MARK: UITableViewDataSource protocol methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: dequeue the cell we want, fill its subviews, and return it
        if let unwrappedPoll = poll, cell = tableView.dequeueReusableCellWithIdentifier(PollActivityResultTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PollActivityResultTableViewCell {
            let currentOption = unwrappedPoll.Options[indexPath.row]
            cell.activityNameLabel.text = currentOption.Name
            cell.activitySatisfactionLabel.text = "Satisfaction: \(unwrappedPoll.Results[indexPath.row] * 100)%"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll?.Options.count ?? 0
    }

}