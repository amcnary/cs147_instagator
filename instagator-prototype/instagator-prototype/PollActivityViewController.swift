//
//  PollActivityViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/24/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol PollActivityViewControllerDelegate {
    func pollActivityViewController(pollActivityViewController: PollActivityViewController, savedPoll: Poll)
}

class PollActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
CreateActivityViewControllerDelegate {
    // MARK: Interface Outlets
    @IBOutlet weak var pollActivityNameTextView: UITextField!
    @IBOutlet weak var pollActivityDescriptionTextView: UITextView!
    @IBOutlet weak var pollActivityOptionsTableView: UITableView!
    @IBOutlet weak var pollActivityMembersTableView: UITableView!
    
    // MARK: other variables
    
    var poll: Poll? {
        didSet {
            if let unwrappedPoll = self.poll {
                self.pollOptions = unwrappedPoll.Options
                // set the participants set
                var newParticipants: Set<Person> = []
                for participant in unwrappedPoll.People {
                    newParticipants.insert(participant)
                }
                self.pollParticipants = newParticipants
            }
        }
    }
    var trip: Trip? {
        didSet {
            if let unwrappedTrip = self.trip {
                self.tripMembers = unwrappedTrip.Members.map({ return $0.0 })
            }
        }
    }
    
    var delegate: PollActivityViewControllerDelegate?
    var tripMembers: [Person] = []
    var pollOptions: [Event] = []
    private var pollParticipants: Set<Person> = []
    var selectedEventIndexPath: NSIndexPath?
    static let presentCreateActivityViewControllerSegueIdentifier = "presentCreateActivityViewControllerSegue"
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        let pollActivityOptionNib = UINib(nibName: PollOptionTableViewCell.reuseIdentifier,
            bundle: nil)
        self.pollActivityOptionsTableView.registerNib(pollActivityOptionNib, forCellReuseIdentifier: PollOptionTableViewCell.reuseIdentifier)
        let personTableViewCellNib = UINib(nibName: PersonTableViewCell.reuseIdentifier, bundle: nil)
        self.pollActivityMembersTableView.registerNib(personTableViewCellNib,
            forCellReuseIdentifier: PersonTableViewCell.reuseIdentifier)
        if let unwrappedPoll = self.poll {
            self.pollActivityNameTextView.text = unwrappedPoll.Name
            self.pollActivityDescriptionTextView.text = unwrappedPoll.Description == "" ? "Poll description (optional)" : unwrappedPoll.Description
        }
        
        self.pollActivityOptionsTableView.reloadData()
        self.pollActivityMembersTableView.reloadData()
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == PollActivityViewController.presentCreateActivityViewControllerSegueIdentifier,
            let createActivityViewController = segue.destinationViewController as? CreateActivityViewController {
                createActivityViewController.delegate = self
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    // MARK: UITableViewDataSource protocol methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch tableView {
        case self.pollActivityOptionsTableView:
            if let pollOptionCell = tableView.dequeueReusableCellWithIdentifier(
                PollOptionTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PollOptionTableViewCell {
                    let currentOption = pollOptions[indexPath.row]
                    pollOptionCell.activityNameLabel.text = currentOption.Name
                    pollOptionCell.activityDescriptionLabel.text = currentOption.Description
                    let startTime = dateTimeFormatter.stringFromDate(currentOption.StartDate)
                    let endTime = dateTimeFormatter.stringFromDate(currentOption.EndDate)
                    pollOptionCell.activityDatesLabel.text = "\(startTime) to \(endTime)"
                    if let projectedCost = currentOption.Cost {
                        pollOptionCell.activityProjectedCostLabel.text = "$\(projectedCost)0"
                    } else {
                        pollOptionCell.activityProjectedCostLabel.hidden = true
                    }
                    return pollOptionCell
            }
            
        case self.pollActivityMembersTableView:
            if let pollActivityMemberCell = tableView.dequeueReusableCellWithIdentifier(
                PersonTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? PersonTableViewCell {
                    
                    let currentMember = self.tripMembers[indexPath.row]
                    pollActivityMemberCell.accessoryType = self.pollParticipants.contains(currentMember) ? .Checkmark : .None
                    pollActivityMemberCell.personImageView.image    = currentMember.Pic
                    pollActivityMemberCell.personNameLabel.text     = "\(currentMember.FirstName) \(currentMember.LastName)"
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
            return self.pollOptions.count
        case self.pollActivityMembersTableView:
            return self.tripMembers.count
        default:
            return 0
        }
    }
    
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView {
        case self.pollActivityOptionsTableView:
            if let editActivityViewController = UIStoryboard(name: "Main",
                bundle: nil).instantiateViewControllerWithIdentifier("CreateActivityViewController")
                as? CreateActivityViewController {
                    editActivityViewController.event = self.poll?.Options[indexPath.row]
                    editActivityViewController.delegate = self
                    editActivityViewController.modalPresentationStyle = .Popover
                    editActivityViewController.popoverPresentationController?.delegate = self
                    editActivityViewController.popoverPresentationController?.canOverlapSourceViewRect = true
                    editActivityViewController.popoverPresentationController?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
                    editActivityViewController.popoverPresentationController?.sourceRect = tableView.cellForRowAtIndexPath(indexPath)?.bounds ?? tableView.frame
                    selectedEventIndexPath = indexPath
                    self.presentViewController(editActivityViewController, animated: true, completion: nil)
            }
            return
            
        case self.pollActivityMembersTableView:
            let selectedMember = tripMembers[indexPath.item]
            if self.pollParticipants.contains(selectedMember) {
                // remove the person from the poll
                self.pollParticipants.remove(selectedMember)
            } else {
                // include the person in the poll!
                self.pollParticipants.insert(selectedMember)
            }
            self.pollActivityMembersTableView.reloadData()
        default:
            return
        }
    }
    
    
    // MARK: CreateActivityViewControllerDelegate protocol methods
    
    func createActivityControllerSaveTapped(createActivityController: CreateActivityViewController, savedEvent event: Event){
        dismissViewControllerAnimated(true, completion: nil)
        if let indexPath = selectedEventIndexPath {
            self.pollOptions[indexPath.row] = event
            selectedEventIndexPath = nil
        } else {
            self.pollOptions.append(event)
        }
        self.pollActivityOptionsTableView.reloadData()
    }
    
    
    // MARK: interface outlets
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        let formErrorAlertController = UIAlertController(title: "Form Error", message: "", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        formErrorAlertController.addAction(confirmAction)
        
        // make sure required fields have been set by the user
        if self.pollOptions.count <= 0 {
            formErrorAlertController.message = "You must add event options to the poll!"
            self.presentViewController(formErrorAlertController, animated: true, completion: nil)
            return
        }
        if self.pollParticipants.count <= 0 {
            formErrorAlertController.message = "You must add poll participants to the poll!"
            self.presentViewController(formErrorAlertController, animated: true, completion: nil)
            return
        }
        guard let pollName = self.pollActivityNameTextView.text where pollName != "" else {
            formErrorAlertController.message = "You must set a poll name!"
            self.presentViewController(formErrorAlertController, animated: true, completion: nil)
            return
        }
        
        // create the new poll object
        let pollDescription = (self.pollActivityDescriptionTextView.text != "Poll description (optional)") ? self.pollActivityDescriptionTextView.text : ""
        let pollOptions = self.pollOptions
        let pollParticipants = self.pollParticipants.map({ return $0 })
        
        let pollToReturn = Poll(
            name: pollName,
            description: pollDescription ?? "",
            options: pollOptions,
            results: [Double](count: pollOptions.count, repeatedValue: 0.0),
            people: pollParticipants,
            numPeopleResponded: 0
        )

        // if the poll will change, alert the user
        if self.poll != nil {
            let pollChangeAlertController = UIAlertController(title: "Warning",
                message: "Changing this poll will reset the poll responses. Continue?", preferredStyle: .Alert)
            let continueAction = UIAlertAction(title: "Continue", style: .Default, handler: { _ in
                self.delegate?.pollActivityViewController(self, savedPoll: pollToReturn)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            pollChangeAlertController.addAction(cancelAction)
            pollChangeAlertController.addAction(continueAction)
            self.presentViewController(pollChangeAlertController, animated: true, completion: nil)
        } else {
            // a new poll is being created, so just save it
            self.delegate?.pollActivityViewController(self, savedPoll: pollToReturn)
        }
    }
}