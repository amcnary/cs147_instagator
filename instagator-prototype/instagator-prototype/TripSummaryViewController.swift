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
UITableViewDataSource, UITableViewDelegate, EditTripViewControllerDelegate, ActivityTableViewCellDelegate,
CreateActivityViewControllerDelegate, PollActivityViewControllerDelegate, PollResultsViewControllerDelegate,
CreateTaskViewControllerDelegate, MemberStatusControllerDelegate {
    
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
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    @IBOutlet var plannedTripExclusiveViews: [UIButton]!
    @IBOutlet weak var inviteeTasksLabel: UILabel!
    

    // MARK: other properties
    
    var trip: Trip?
    var delegate: TripSummaryViewControllerDelegate?
    var tripOwnershipType: TripListViewController.TripOwnershipType = .Planning
    var selectedActivityIndexPath: NSIndexPath?
    var selectedMemberIndexPath: NSIndexPath?
    var selectedTaskIndexPath: NSIndexPath?
    
    // MARK: helper utility functions
    
    func updateUI() {
        if let unwrappedTrip = trip {
            switch self.tripOwnershipType {
            case .Planning:
                let acceptedMembers = unwrappedTrip.Members.filter({ $0.1 == .Accepted })
                let pendingMembers = unwrappedTrip.Members.filter({ $0.1 == .Pending })
                inviteesHeaderLabel.text    = "Invitees (\(acceptedMembers.count) attending, \(pendingMembers.count) awaiting response)"
            case .Attending:
                for plannedTripExclusiveView in self.plannedTripExclusiveViews {
                    plannedTripExclusiveView.hidden = true
                }
                inviteesHeaderLabel.text    = "Who's Going"
                navigationBarItem.rightBarButtonItems = nil
                inviteeTasksLabel.text      = "Your Tasks"
            }
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
            
            tripActivitiesTableView.tableFooterView = UIView(frame: CGRectZero)
            tripTasksTableView.tableFooterView      = UIView(frame: CGRectZero)
        }
    }
    
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        updateUI()
        switch self.tripOwnershipType {
        case .Planning:
            break
        case .Attending:
            for plannedTripExclusiveView in self.plannedTripExclusiveViews {
                plannedTripExclusiveView.hidden = true
            }
            navigationBarItem.rightBarButtonItems = nil
        }
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let id = segue.identifier, editViewController = segue.destinationViewController as? EditTripViewController where id == "SummaryToEditSegue" {
            editViewController.trip = self.trip
            editViewController.delegate = self
        } else if let id = segue.identifier, createTaskController = segue.destinationViewController as? CreateTaskViewController where id == "presentCreateTaskViewControllerSegue" {
            createTaskController.delegate = self
            if let unwrappedTrip = self.trip {
                createTaskController.trip = unwrappedTrip
            }
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
                            createActivityViewController.delegate = self
                            createActivityViewController.modalPresentationStyle = .Popover
                            createActivityViewController.popoverPresentationController?.delegate = self
                            createActivityViewController.popoverPresentationController?.canOverlapSourceViewRect = true
                            createActivityViewController.popoverPresentationController?.sourceView = sender
                            createActivityViewController.popoverPresentationController?.sourceRect = sender.frame
                            self.presentViewController(createActivityViewController, animated: true, completion: nil)
                    }
                    
                case "Poll":
                    if let pollActivityViewController = UIStoryboard(name: "Main",
                        bundle: nil).instantiateViewControllerWithIdentifier("PollActivityViewController")
                        as? PollActivityViewController {
                            pollActivityViewController.trip = self.trip
                            pollActivityViewController.delegate = self
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

        if let currentMember = self.tripMemberAtIndexPath(indexPath), cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            InviteeCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? InviteeCollectionViewCell {
                
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
            currentMember = self.tripMemberAtIndexPath(indexPath) {
                selectedMemberIndexPath = indexPath
                memberStatusViewController.member = currentMember.member
                memberStatusViewController.delegate = self
                memberStatusViewController.tripOwnershipType = tripOwnershipType
                memberStatusViewController.modalPresentationStyle = .Popover
                if let popoverController = memberStatusViewController.popoverPresentationController {
                    popoverController.canOverlapSourceViewRect = true
                    popoverController.sourceView = collectionView.cellForItemAtIndexPath(indexPath)
                    popoverController.sourceRect = collectionView.cellForItemAtIndexPath(indexPath)?.bounds ?? collectionView.frame
                    popoverController.delegate   = self
                }
                memberStatusViewController.trip = self.trip
                self.presentViewController(memberStatusViewController, animated: true, completion: nil)
        }
    }
    
    private func tripMemberAtIndexPath(indexPath: NSIndexPath) -> (member: Person, memberRSVPStatus: Trip.RSVPStatus)? {
        return self.trip?.Members.map({ return $0 })[indexPath.row]
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
                        switch self.tripOwnershipType {
                        case .Planning:
                            break
//                            cell.viewResultsButton.setTitle("View Results", forState: .Normal)
                        case .Attending:
                            cell.viewResultsButton.enabled = false
//                            cell.viewResultsButton.setTitle("Tap to Vote", forState: .Normal)
                        }
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
                    cell.taskTitleLabel.text      = currentTask.Name
                    
                    switch self.tripOwnershipType {
                    case .Planning:
                        cell.taskInviteeProgressLabel.text  = "\(currentTask.NumUsersCompleted)/\(currentTask.MemberTaskStatuses.count)"
                    case .Attending:
                        cell.taskInviteeProgressLabel.hidden = true//text  = currentTask.MemberTaskStatuses[currentUser]?.rawValue
                        cell.accessoryType = currentTask.MemberTaskStatuses[people[5]] == .Complete ? .Checkmark : .None
                    }
                    
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
                        editActivityViewController.delegate = self
                        editActivityViewController.tripOwnershipType = .Attending
                        editActivityViewController.modalPresentationStyle = .Popover
                        editActivityViewController.popoverPresentationController?.canOverlapSourceViewRect = true
                        editActivityViewController.popoverPresentationController?.delegate = self
                        editActivityViewController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
                        editActivityViewController.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.bounds ?? tableView.frame
                        selectedActivityIndexPath = indexPath
                        self.presentViewController(editActivityViewController, animated: true, completion: nil)
                }
                
            case let poll as Poll where self.tripOwnershipType == .Attending:
                if let pollVoteViewController = UIStoryboard(name: "Main",
                    bundle: nil).instantiateViewControllerWithIdentifier("PollVoteViewController")
                    as? PollVoteViewController {
                        
                        pollVoteViewController.poll = poll
                        pollVoteViewController.modalPresentationStyle = .Popover
                        pollVoteViewController.popoverPresentationController?.delegate = self
                        pollVoteViewController.popoverPresentationController?.canOverlapSourceViewRect = true
                        pollVoteViewController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
                        pollVoteViewController.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.bounds ?? tableView.frame
                        self.presentViewController(pollVoteViewController, animated: true, completion: nil)
                }
            case let poll as Poll where self.tripOwnershipType == .Planning:
                if let pollActivityViewController = UIStoryboard(name: "Main",
                    bundle: nil).instantiateViewControllerWithIdentifier("PollActivityViewController")
                    as? PollActivityViewController {
                        
                        pollActivityViewController.delegate = self
                        pollActivityViewController.trip = self.trip
                        pollActivityViewController.poll = poll
                        selectedActivityIndexPath = indexPath
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
                    editTaskViewController.delegate = self
                    editTaskViewController.tripOwnershipType = self.tripOwnershipType
                    if let unwrappedTrip = self.trip {
                        editTaskViewController.trip = unwrappedTrip
                    }
                    editTaskViewController.modalPresentationStyle = .Popover
                    if let popoverController = editTaskViewController.popoverPresentationController {
                        popoverController.canOverlapSourceViewRect = true
                        popoverController.sourceView = tableView.cellForRowAtIndexPath(indexPath)
                        popoverController.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.bounds ?? tableView.frame
                        popoverController.delegate   = self
                    }
                    selectedTaskIndexPath = indexPath
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
                        pollResultsViewController.delegate = self
                        pollResultsViewController.poll = poll
                        selectedActivityIndexPath = indexPath
                        self.navigationController?.pushViewController(pollResultsViewController, animated: true)
            }
    }
    
    // MARK: CreateActivityViewControllerDelegate protocol methods
    func createActivityControllerSaveTapped(createActivityController: CreateActivityViewController, savedEvent event: Event){
        dismissViewControllerAnimated(true, completion: nil)
        if let indexPath = selectedActivityIndexPath {
            trip?.Activities[indexPath.row] = event
            selectedActivityIndexPath = nil
        } else {
            trip?.Activities.append(event)
        }
        updateUI()
    }


    // MARK: PollActivityViewControllerDelegate protocol methods
    
    func pollActivityViewController(pollActivityViewController: PollActivityViewController, savedPoll: Poll) {
        self.navigationController?.popViewControllerAnimated(true)
        if let indexPath = selectedActivityIndexPath {
            trip?.Activities[indexPath.row] = savedPoll
            selectedActivityIndexPath = nil
        } else {
            trip?.Activities.append(savedPoll)
        }
        updateUI()
    }
    
    // MARK: PollResultsViewControllerDelegate protocol methods
    func pollResultsViewController(pollResultsViewController: PollResultsViewController, selectAndSaveButtonTappedForEvent event: Event) {
        self.navigationController?.popViewControllerAnimated(true)
        if let indexPath = selectedActivityIndexPath {
            trip?.Activities[indexPath.row] = event
            selectedActivityIndexPath = nil
        }
        updateUI()
    }
    
    // MARK: CreateTaskViewControllerDelegate protocol methods
    func createTaskControllerSaveTapped(createTaskViewController: CreateTaskViewController, savedTask task: Task) {
        dismissViewControllerAnimated(true, completion: nil)
        if let indexPath = selectedTaskIndexPath {
            trip?.Tasks[indexPath.row] = task
            selectedTaskIndexPath = nil
        } else {
            trip?.Tasks.append(task)
        }
        updateUI()
        
    }
    
    // MARK: MemberStatusControllerDelegate protocol methods
    func memberChangeAdminStatusButtonTapped(memberStatusViewController: MemberStatusViewController) {
        if let indexPath = self.selectedMemberIndexPath, unwrappedTrip = self.trip, memberToUpdate = self.tripMemberAtIndexPath(indexPath) {
            if unwrappedTrip.Admins.contains(memberToUpdate.member) {
                unwrappedTrip.Admins.remove(memberToUpdate.member)
            } else {
                unwrappedTrip.Admins.insert(memberToUpdate.member)
            }
            updateUI()
        }
    }
    
    func memberRemoveFromTripButtonTapped(memberStatusViewController: MemberStatusViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        if let indexPath = self.selectedMemberIndexPath, memberToRemove = self.tripMemberAtIndexPath(indexPath) {
            self.selectedMemberIndexPath = nil
            self.trip?.Members.removeValueForKey(memberToRemove.member)
            updateUI()
        }
    }
    
}