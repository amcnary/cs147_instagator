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
UITableViewDataSource, UITableViewDelegate, EditTripViewControllerDelegate, ActivityTableViewCellDelegate {
    
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
    
    
    // MARK: interface actions
    
    @IBAction func addActivityButtonTapped(sender: UIButton) {
        let alertController = UIAlertController(title: "Select New Event Type", message: "", preferredStyle: .Alert)
        
        func eventTypeHandler(alertAction: UIAlertAction) {
            if let title = alertAction.title {
                
                switch title {
                    
                case "Static":
                    if let createActivityViewController = UIStoryboard(name: "Main",
                        bundle: nil).instantiateViewControllerWithIdentifier("CreateActivityViewController")
                        as? CreateActivityViewController {
                            createActivityViewController.modalPresentationStyle = .Popover
                            createActivityViewController.popoverPresentationController?.delegate = self
                            createActivityViewController.popoverPresentationController?.sourceView = sender
                            createActivityViewController.popoverPresentationController?.sourceRect = sender.frame
                            self.presentViewController(createActivityViewController, animated: true, completion: nil)
                    }
                    
                case "Poll":
                    if let pollActivityViewController = UIStoryboard(name: "Main",
                        bundle: nil).instantiateViewControllerWithIdentifier("PollActivityViewController")
                        as? PollActivityViewController {
                            pollActivityViewController.trip = self.trip
                            self.navigationController?.pushViewController(pollActivityViewController, animated: true)
                    }
                    
                default:
                    break
                }
                
            }
        }
        let staticEventTypeAction = UIAlertAction(title: "Static", style: .Default, handler: eventTypeHandler)
        let pollEventTypeAction = UIAlertAction(title: "Poll", style: .Default, handler: eventTypeHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(staticEventTypeAction)
        alertController.addAction(pollEventTypeAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
    
    
    // MARK: UICollectionView delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let memberStatusViewController = UIStoryboard(name: "Main",
            bundle: nil).instantiateViewControllerWithIdentifier("MemberStatusViewController") as? MemberStatusViewController,
            currentMember = self.trip?.Members[indexPath.item] {
                memberStatusViewController.member = currentMember.member
                memberStatusViewController.modalPresentationStyle = .Popover
                if let popoverController = memberStatusViewController.popoverPresentationController {
                    popoverController.sourceView = collectionView
                    popoverController.sourceRect = collectionView.frame
                    popoverController.delegate   = self
                }
                memberStatusViewController.trip = self.trip
                self.presentViewController(memberStatusViewController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: UITableViewDataSource protocol methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.tripActivitiesTableView:
            if let tripActivities = self.trip?.Activities, cell = tableView.dequeueReusableCellWithIdentifier(
                ActivityTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ActivityTableViewCell {
                    
                    let currentActivity                 = tripActivities[indexPath.item]
                    cell.delegate                       = self
                    cell.indexPath                      = indexPath
                    cell.activityNameLabel.text         = currentActivity.Name
                    
                    // populate the cell based on what kind of activity is being displayed
                    switch currentActivity {
                    case let event as Event:
                        cell.activityPollStatusLabel.text = "Fixed Event"
                        let startDateString                 = dateTimeFormatter.stringFromDate(event.StartDate)
                        let endDateString                   = dateTimeFormatter.stringFromDate(event.EndDate)
                        cell.activityDateLabel.text         = "\(startDateString) to \(endDateString)"
                        cell.viewResultsButton.hidden = true
                        
                    case _ as Poll:
                        cell.activityPollStatusLabel.text = "Poll Event"
                        cell.activityDateLabel.hidden = true
                    default:
                        break
                    }

                    return cell
            }
            
        case self.tripTasksTableView:
            if let tripTasks = self.trip?.Tasks, cell = tableView.dequeueReusableCellWithIdentifier(
                TaskTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? TaskTableViewCell {
                    
                    let currentTask = tripTasks[indexPath.item]
                    cell.taskDeadlineLabel.text         = "Due: \(dateTimeFormatter.stringFromDate(currentTask.DueDate))"
                    cell.taskDescriptionLabel.text      = currentTask.Description
                    cell.taskInviteeProgressLabel.text  = "\(currentTask.NumUsersCompleted)/\(currentTask.MemberTaskStatus.count)"
                    
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
            return self.trip?.Activities.count ?? 0
        case self.tripTasksTableView:
            return self.trip?.Tasks.count ?? 0
        default:
            return 0
        }
    }
    
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView {
        case self.tripActivitiesTableView:
            
            guard let currentActivity = self.trip?.Activities[indexPath.row] else {
                return
            }
            
            // present a different view controller for polls and static events
            switch currentActivity {
                
            case let event as Event:
                if let editActivityViewController = UIStoryboard(name: "Main",
                    bundle: nil).instantiateViewControllerWithIdentifier("CreateActivityViewController")
                    as? CreateActivityViewController {
                        editActivityViewController.event = event
                        editActivityViewController.modalPresentationStyle = .Popover
                        editActivityViewController.popoverPresentationController?.delegate = self
                        editActivityViewController.popoverPresentationController?.sourceView = tableView
                        editActivityViewController.popoverPresentationController?.sourceRect = tableView.frame
                        self.presentViewController(editActivityViewController, animated: true, completion: nil)
                }
                
            case let poll as Poll:
                if let pollActivityViewController = UIStoryboard(name: "Main",
                    bundle: nil).instantiateViewControllerWithIdentifier("PollActivityViewController")
                    as? PollActivityViewController {
                        
                        pollActivityViewController.trip = self.trip
                        pollActivityViewController.poll = poll
                        self.navigationController?.pushViewController(pollActivityViewController, animated: true)
                }
                
            default:
                break
            }
            
            
        case self.tripTasksTableView:
            if let editTaskViewController = UIStoryboard(name: "Main",
                bundle: nil).instantiateViewControllerWithIdentifier("CreateTaskViewController") as? CreateTaskViewController,
                task = self.trip?.Tasks[indexPath.row] {
                    editTaskViewController.task = task
                    editTaskViewController.modalPresentationStyle = .Popover
                    if let popoverController = editTaskViewController.popoverPresentationController {
                        popoverController.sourceView = tableView
                        popoverController.sourceRect = tableView.frame
                        popoverController.delegate   = self
                    }
                    self.presentViewController(editTaskViewController, animated: true, completion: nil)
            }
        default:
            break
        }
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
    
    
    // MARK: ActivityTableViewCellDelegate protocol methods
    
    func activityTableViewCell(activityTableViewCell: ActivityTableViewCell,
        viewPollResultsTappedAtIndexPath indexPath: NSIndexPath) {
            if let poll = self.trip?.Activities[indexPath.row] as? Poll,
                pollResultsViewController = UIStoryboard(name: "Main",
                    bundle: nil).instantiateViewControllerWithIdentifier("PollResultsViewController")
                    as? PollResultsViewController {
                        
                        pollResultsViewController.poll = poll
                        self.navigationController?.pushViewController(pollResultsViewController, animated: true)
            }
    }
}








