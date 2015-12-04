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
    func tripSummaryRemovePlannedTripPressed(tripSummaryViewController: TripSummaryViewController)
    func tripSummaryRemoveAttendingTripPressed(tripSummaryViewController: TripSummaryViewController)
}



class TripSummaryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDataSource, UITableViewDelegate, EditTripViewControllerDelegate, ActivityTableViewCellDelegate,
CreateActivityViewControllerDelegate, PollActivityViewControllerDelegate, PollResultsViewControllerDelegate,
CreateTaskViewControllerDelegate, MemberStatusControllerDelegate, PollVoteViewControllerDelegate {
    
    static let storyboardId = "TripSummaryViewController"
    
    
    // MARK: interface outlets

    @IBAction func tripTasksListInfoButtonTapped(sender: AnyObject) {
        self.presentConfirmationMessage("Tasks are set by trip admins. An admin can tap to edit tasks or swipe left to delete items. Participants can tap to view details and swipe left to mark a task as completed. ")
    }
    @IBAction func tripActivitiesListInfoButtonTapped(sender: AnyObject) {
        self.presentConfirmationMessage("Activities are either fixed, or not up for debate, or polls, which take into account user input. Admins can tap to view/edit activity details or swipe to delete. Attendees can tap to view static info or vote on poll events.")
    }
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
    
    @IBOutlet var abandonTripButton: UIView!
    @IBAction func abandonTripButtonTapped(sender: AnyObject) {
        // alert the user that they are about to commit a dick move
        if let unwrappedTrip = self.trip {
            let alertController = UIAlertController(title: "Warning", message: "You are about to abandon \(unwrappedTrip.Name). Continue?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let continueAction = UIAlertAction(title: "Continue", style: .Default, handler: { _ in
                if self.tripOwnershipType == .Planning {
                    self.delegate?.tripSummaryRemovePlannedTripPressed(self)
                } else {
                    self.delegate?.tripSummaryRemoveAttendingTripPressed(self)
                }
                return
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(continueAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

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
                            createActivityViewController.trip = self.trip
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

        if let currentMember = self.tripMemberAtIndexPath(indexPath), unwrappedTrip = self.trip,
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            InviteeCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? InviteeCollectionViewCell {
                cell.inviteeImageView.image         = currentMember.member.Pic
                cell.inviteeNameLabel.text          = "\(currentMember.member.FirstName)"
                
                if currentMember.memberRSVPStatus == .Accepted {
                    let tasksLeft                       = unwrappedTrip.Tasks.count -
                                                            unwrappedTrip.numTasksCompletedByMember(currentMember.member)
                    switch tasksLeft {
                    case 0:
                        cell.inviteeTasksToDoLabel.text   = " "
                    case 1:
                        cell.inviteeTasksToDoLabel.text   = "\(tasksLeft) task outstanding"
                    default:
                        cell.inviteeTasksToDoLabel.text   = "\(tasksLeft) tasks outstanding"
                    }
                    cell.inviteeRSVPStatusLabel.text      = "Attending"
                    cell.inviteeRSVPStatusLabel.textColor = UIColor(red: 80/255.0, green: 150/255.0, blue: 80/255.0, alpha: 0.9)
                    
                } else {
                    cell.inviteeRSVPStatusLabel.text      = "Awaiting Response"
                    cell.inviteeRSVPStatusLabel.textColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 0.8)
                }

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
                        cell.activityDateLabel.hidden = false
                        
                    case _ as Poll:
                        cell.activityPollStatusLabel.text   = "Poll Event"
                        cell.activityDateLabel.hidden       = true
                        switch self.tripOwnershipType {
                        case .Planning:
                            cell.viewResultsButton.hidden   = false
                            break
                        case .Attending:
                            cell.viewResultsButton.enabled = false
                            cell.viewResultsButton.setTitle("Tap to Vote", forState: .Disabled)
                            cell.viewResultsButton.setTitleColor(UIColor.redColor(), forState: .Disabled)
                        }
                        
                    case _ as PendingPoll:
                        cell.viewResultsButton.hidden       = true
                        cell.activityPollStatusLabel.text   = "Awaiting Results"
                        cell.activityDateLabel.hidden       = true
                        cell.userInteractionEnabled = false

                    default:
                        break
                    }

                    return cell
            }
            
        case self.tripTasksTableView:
            if let unwrappedTrip = self.trip, cell = tableView.dequeueReusableCellWithIdentifier(
                TaskTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? TaskTableViewCell {
                    
                    let currentTask = unwrappedTrip.Tasks[indexPath.item]
                    cell.taskDeadlineLabel.text         = "Due: \(dateTimeFormatter.stringFromDate(currentTask.DueDate))"
                    cell.taskTitleLabel.text      = currentTask.Name
                    
                    switch self.tripOwnershipType {
                    case .Planning:
                        let numAcceptedMembers = unwrappedTrip.Members.filter({ $0.1 == .Accepted }).count
                        cell.taskInviteeProgressLabel.text  = "\(currentTask.NumUsersCompleted)/\(numAcceptedMembers)"
                    case .Attending:
                        cell.taskInviteeProgressLabel.hidden = true
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
                        editActivityViewController.trip = self.trip
                        editActivityViewController.delegate = self
                        editActivityViewController.tripOwnershipType = self.tripOwnershipType
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
                        pollVoteViewController.delegate = self
                        selectedActivityIndexPath = indexPath
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let unwrappedTrip = self.trip {
            return self.tripOwnershipType == .Planning || (tableView == self.tripTasksTableView && !unwrappedTrip.Tasks[indexPath.row].memberHasCompletedTask(people[5]))
        }
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let unwrappedTrip = self.trip {
                switch tableView {
                case self.tripActivitiesTableView:
                    unwrappedTrip.Activities.removeAtIndex(indexPath.row)
                case self.tripTasksTableView:
                    unwrappedTrip.Tasks.removeAtIndex(indexPath.row)
                default:
                    break
                }
                updateUI()
            }
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if self.tripOwnershipType == .Attending {
            let completeTask = UITableViewRowAction(style: .Normal, title: "Complete") { action, index in
                if let unwrappedTrip = self.trip {
                    unwrappedTrip.Tasks[indexPath.row].MemberTaskStatuses[people[5]] = .Complete
                    self.updateUI()
                }
            }
            completeTask.backgroundColor = UIColor.greenColor()
            return [completeTask]
        }
        
        // return a single item for delete
        let deleteTask = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            if let unwrappedTrip = self.trip {
                unwrappedTrip.Tasks.removeAtIndex(indexPath.row)
                self.updateUI()
            }
        }
//        deleteTask.backgroundColor = UIColor.blueColor()
        return [deleteTask]
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
    func createActivityControllerSaveTapped(createActivityController: CreateActivityViewController, savedEvent event: Event) {
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
            self.tripActivitiesTableView.reloadData()
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
    
    // MARK: PollVoteViewControllerDelegate
    func pollVoteViewControllerSubmitPressed(pollVoteViewController: PollVoteViewController) {
        dismissViewControllerAnimated(true, completion: nil)
        if let indexPath = selectedActivityIndexPath, var tripActivities = self.trip?.Activities {
            let newFixedEvent: PendingPoll = PendingPoll(name: tripActivities[indexPath.row].Name, description: "Awaiting poll results!")
            self.trip?.Activities[indexPath.row] = newFixedEvent
            updateUI()
        }
        selectedActivityIndexPath = nil
    }
    
}