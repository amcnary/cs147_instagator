//
//  TripSummaryViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol TripSummaryViewControllerDelegate {
    func tripSummaryViewControllerEditedTrip(tripSummaryViewController: TripSummaryViewController)
}

class TripSummaryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDataSource, UITableViewDelegate, EditTripViewControllerDelegate {
    
    static let storyboardId = "TripSummaryViewController"
    
    // MARK: interface outlets

    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripDestinationLabel: UILabel!
    @IBOutlet weak var tripDatesLabel: UILabel!
    @IBOutlet weak var tripDescriptionLabel: UILabel!
    @IBOutlet weak var inviteesHeaderLabel: UILabel!
    @IBOutlet weak var tripInviteesCollectionView: UICollectionView!
    @IBOutlet weak var tripActivitiesTableView: UITableView!
    @IBOutlet weak var tripTasksTableView: UITableView!
    

    // MARK: properties
    
    var trip: Trip?
    var delegate: TripSummaryViewControllerDelegate?
    
    // MARK: helper utility functions
    func updateUI() {
        if let unwrappedTrip = trip {
            tripTitleLabel.text         = unwrappedTrip.Name
            tripImageView.image         = unwrappedTrip.Image
            tripDestinationLabel.text   = unwrappedTrip.Destination
            tripDescriptionLabel.text   = unwrappedTrip.Description
            let startDateString         = dateFormatter.stringFromDate(unwrappedTrip.StartDate)
            let endDateString           = dateFormatter.stringFromDate(unwrappedTrip.EndDate)
            tripDatesLabel.text         = "\(startDateString) to \(endDateString)"
            
            tripInviteesCollectionView.reloadData()
            tripActivitiesTableView.reloadData()
            tripTasksTableView.reloadData()
            
            let acceptedMembers      = unwrappedTrip.Members.filter({ (memberInfo: (member: Person, memberRSVPStatus: Trip.RSVPStatus)) -> Bool in
                return memberInfo.memberRSVPStatus == .Accepted
            })
            let pendingMembers       = unwrappedTrip.Members.filter({ (memberInfo: (member: Person, memberRSVPStatus: Trip.RSVPStatus)) -> Bool in
                return memberInfo.memberRSVPStatus == .Pending
            })
            
            inviteesHeaderLabel.text    = "Invitees (\(acceptedMembers.count) attending, \(pendingMembers.count) awaiting response)"
            
            tripActivitiesTableView.tableFooterView = UIView(frame: CGRectZero)
            tripTasksTableView.tableFooterView      = UIView(frame: CGRectZero)
            

        }
    }
    
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        updateUI()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let id = segue.identifier, editViewController = segue.destinationViewController as? EditTripViewController where id == "SummaryToEditSegue" {
            editViewController.trip = self.trip
            editViewController.delegate = self
        }
    }
    
    
    // MARK: UICollectionViewDataSource protocol methods

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if let tripMembers = self.trip?.Members, cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            InviteeCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? InviteeCollectionViewCell {
                
                let currentMember = tripMembers[indexPath.item]
                cell.inviteeImageView.image         = currentMember.member.Pic
                cell.inviteeNameLabel.text          = "\(currentMember.member.FirstName)"
                cell.inviteeTasksToDoLabel.text     = "No ToDos!"
                cell.inviteeRSVPStatusLabel.text    = currentMember.memberRSVPStatus == .Accepted ? "Attending!" : "Awaiting Response"
                
                cell.inviteeRSVPStatusLabel.textColor = currentMember.memberRSVPStatus == .Accepted ? UIColor(red: 80/255.0, green: 220/255.0, blue: 80/255.0, alpha: 0.9) : UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 0.8)

                return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trip?.Members.count ?? 0
    }
    
    // MARK: UITableViewDataSource protocol methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tripActivitiesTableView:
            if let tripEvents = self.trip?.Events, cell = tableView.dequeueReusableCellWithIdentifier(ActivityTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ActivityTableViewCell {
                    
                    let currentActivity                 = tripEvents[indexPath.item]
                    cell.activityNameLabel.text         = currentActivity.Name
                    cell.activityPollStatusLabel.text   = currentActivity.EventPoll == nil ? "Fixed Event" : "Poll Event"
                    let startDateString                 = dateTimeFormatter.stringFromDate(currentActivity.StartDate)
                    let endDateString                   = dateTimeFormatter.stringFromDate(currentActivity.EndDate)
                    cell.activityDateLabel.text         = "\(startDateString) to \(endDateString)"
                    if(currentActivity.EventPoll == nil){
                        cell.viewResultsButton.hidden = true
                    }
                    return cell
            }
            
        case self.tripTasksTableView:
            if let tripTasks = self.trip?.Tasks, cell = tableView.dequeueReusableCellWithIdentifier(
                TaskTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? TaskTableViewCell {
                    
                    let currentTask = tripTasks[indexPath.item]
                    cell.taskDeadlineLabel.text         = "Due: \(dateTimeFormatter.stringFromDate(currentTask.DueDate))"
                    cell.taskDescriptionLabel.text      = currentTask.Description
                    cell.taskInviteeProgressLabel.text  = "4/4"
                    
                    return cell
            }
        default:
            print("what the shit")
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tripActivitiesTableView:
            return self.trip?.Events.count ?? 0
        case self.tripTasksTableView:
            return self.trip?.Tasks.count ?? 0
        default:
            return 0
        }
    }
    
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    
    // MARK: EditTripViewControllerDelegate protocol methods
    
    func editTripConrollerCancelTapped(editTripController: EditTripViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editTripConroller(editTripController: EditTripViewController, savedTrip trip: Trip) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.trip = trip
        updateUI()
        
        // notify anyone who cares that our trip changed
        self.delegate?.tripSummaryViewControllerEditedTrip(self)
    }
    
    
    
}








