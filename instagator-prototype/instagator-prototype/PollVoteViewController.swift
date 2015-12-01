//
//  PollVoteViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

// TODO: make cells reorderable

import Foundation
import UIKit

protocol PollVoteViewControllerDelegate {
    func pollVoteViewControllerSubmitPressed(pollVoteViewController: PollVoteViewController)
}

class PollVoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Interface Outlets
    
    @IBOutlet weak var pollVoteTitleLabel: UILabel!
    @IBOutlet weak var pollOptionsTableView: UITableView!
    
    
    // MARK: other variables
    
    var poll: Poll?
    var delegate: PollVoteViewControllerDelegate?
    
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        let pollActivityOptionNib = UINib(nibName: PollOptionTableViewCell.reuseIdentifier, bundle: nil)
        self.pollOptionsTableView.registerNib(pollActivityOptionNib, forCellReuseIdentifier: PollOptionTableViewCell.reuseIdentifier)
        if let unwrappedPoll = poll {
            self.pollVoteTitleLabel.text = "Vote on \(unwrappedPoll.Name)"
        }
        super.viewDidLoad()
    }
    
    
    // MARK: UITableViewDataSource protocol
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let unwrappedPoll = self.poll, cell = tableView.dequeueReusableCellWithIdentifier(
            PollOptionTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PollOptionTableViewCell {
                let currentOption = unwrappedPoll.Options[indexPath.row]
                cell.activityNameLabel.text = currentOption.Name
                let startTime = dateTimeFormatter.stringFromDate(currentOption.StartDate)
                let endTime = dateTimeFormatter.stringFromDate(currentOption.EndDate)
                cell.activityDatesLabel.text = "\(startTime) to \(endTime)"
                cell.activityDescriptionLabel.text = currentOption.Description
                
                if let projectedCost = currentOption.Cost {
                    cell.activityProjectedCostLabel.text = "$\(projectedCost)"
                }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poll?.Options.count ?? 0
    }
    
    
    // MARK: interface actions
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        delegate?.pollVoteViewControllerSubmitPressed(self)
    }
}