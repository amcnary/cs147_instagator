//
//  PollActivityViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/24/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit


class PollActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Interface Outlets
    @IBOutlet weak var pollActivityOptionsTableView: UITableView!
    @IBOutlet weak var pollActivityMembersTableView: UITableView!
    
    // MARK: other variables
    
    var poll: Poll?
    var trip: Trip?
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        let pollActivityOptionNib = UINib(nibName: PollOptionTableViewCell.reuseIdentifier,
            bundle: nil)
        self.pollActivityOptionsTableView.registerNib(pollActivityOptionNib, forCellReuseIdentifier: PollOptionTableViewCell.reuseIdentifier)

        let personTableViewCellNib = UINib(nibName: PersonTableViewCell.reuseIdentifier, bundle: nil)
        self.pollActivityMembersTableView.registerNib(personTableViewCellNib,
            forCellReuseIdentifier: PersonTableViewCell.reuseIdentifier)
    }
    
    
    // MARK: UITableViewDataSource protocol methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.pollActivityOptionsTableView:
            if let unwrappedPoll = self.poll, pollOptionCell = tableView.dequeueReusableCellWithIdentifier(
                PollOptionTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PollOptionTableViewCell {
                    let currentOption = unwrappedPoll.Options[indexPath.row]
                    pollOptionCell.activityNameLabel.text = currentOption.Name
                    pollOptionCell.activityDescriptionLabel.text = currentOption.Description
                    pollOptionCell.activityProjectedCostLabel.text = "$\(currentOption.Cost)"
                    let startTime = dateTimeFormatter.stringFromDate(currentOption.StartDate)
                    let endTime = dateTimeFormatter.stringFromDate(currentOption.EndDate)
                    pollOptionCell.activityDatesLabel.text = "\(startTime) to \(endTime)"
                    return pollOptionCell
            }
            
        case self.pollActivityMembersTableView:
            if let unwrappedTrip = self.trip, pollActivityMemberCell = tableView.dequeueReusableCellWithIdentifier(
                PersonTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PersonTableViewCell {
                    let currentMember = unwrappedTrip.Members[indexPath.row].member
                    pollActivityMemberCell.personImageView.image = currentMember.Pic
                    pollActivityMemberCell.personNameLabel.text = "\(currentMember.FirstName) \(currentMember.LastName)"
                    return pollActivityMemberCell
            }
        default:
            print("what the shit")
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.pollActivityOptionsTableView:
            return self.poll?.Options.count ?? 0
        case self.pollActivityMembersTableView:
            return self.trip?.Members.count ?? 0
        default:
            return 0
        }
    }
    
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }


}