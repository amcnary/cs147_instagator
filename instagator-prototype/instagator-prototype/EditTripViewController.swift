//
//  EditTripViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol EditTripViewControllerDelegate {
    func editTripConrollerCancelTapped(editTripController: EditTripViewController)
    func editTripConroller(editTripController: EditTripViewController, savedTrip trip: Trip)
}

class EditTripViewController: UIViewController, UINavigationBarDelegate, UITableViewDelegate,
UITableViewDataSource, SelectImageViewControllerDelegate {
    
    // MARK: constants
    
    private static let editTripToSelectImageSegue = "EditTripToSelectImageSegue"
    
    
    // MARK: interface outlets
    
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripImageButton: UIButton!
    @IBOutlet weak var tripDestinationTextField: UITextField!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var tripStartDatePicker: UIDatePicker!
    @IBOutlet weak var tripEndDatePicker: UIDatePicker!
    @IBOutlet weak var tripInviteesHeaderLabel: UILabel!
    @IBOutlet weak var tripInviteesTableView: UITableView!
    
    
    // MARK: other properties
    
    private var invitedPeople: [Person: Trip.RSVPStatus] = [:]
    var trip: Trip? {
        didSet {
            self.invitedPeople = trip?.Members ?? [:]
        }
    }
    var delegate: EditTripViewControllerDelegate?
    var numberInvitees: Int = 0
    
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        if let unwrappedTrip = self.trip {
            self.tripNameTextField.text = unwrappedTrip.Name
            self.tripDestinationTextField.text = unwrappedTrip.Destination
            self.tripDescriptionTextView.text = unwrappedTrip.Description
            self.tripImageButton.setBackgroundImage(unwrappedTrip.Image, forState: .Normal)
            self.tripImageButton.setTitle(nil, forState: .Normal)
            self.tripStartDatePicker.setDate(unwrappedTrip.StartDate, animated: false)
            self.tripEndDatePicker.setDate(unwrappedTrip.EndDate, animated: false)
            numberInvitees = unwrappedTrip.Members.count
            self.tripInviteesHeaderLabel.text = "Invitees (\(unwrappedTrip.Members.count) total)"
        } else {
            self.tripInviteesHeaderLabel.text = "No invitees yet!"
        }
        
        // tell the table view to load a custom cell from a nib
        let personTableViewCellNib = UINib(nibName: PersonTableViewCell.reuseIdentifier, bundle: nil)
        self.tripInviteesTableView.registerNib(personTableViewCellNib,
            forCellReuseIdentifier: PersonTableViewCell.reuseIdentifier)
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let id = segue.identifier, selectImageViewController = segue.destinationViewController as? SelectImageViewController where id == EditTripViewController.editTripToSelectImageSegue {
            selectImageViewController.delegate = self
        }
    }
    
    // this function is needed to display the navigation bar correctly
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Form Error", message: "", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alertController.addAction(confirmAction)
        guard let tripName = self.tripNameTextField.text where tripName != "" else {
            alertController.message = "You must include a trip name!"
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        guard let tripImage = self.tripImageButton.backgroundImageForState(.Normal) else {
            alertController.message = "You must include an image. Go back and select one NOW (thanks)"
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let tripDescription = (self.tripDescriptionTextView.text != "enter trip description (optional)") ? self.tripDescriptionTextView.text : ""
        guard let tripDestination = self.tripDestinationTextField.text where tripDestination != "" else {
            alertController.message = "You have to set a trip destination."
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let tripStartDate = self.tripStartDatePicker.date
        let tripEndDate = self.tripEndDatePicker.date
        
        let tripToReturn: Trip
        if let currentTrip = self.trip {
            tripToReturn = currentTrip
            tripToReturn.Destination = tripDestination
            tripToReturn.Name = tripName
            tripToReturn.Description = tripDescription
            tripToReturn.Image    = tripImage
            tripToReturn.StartDate = tripStartDate
            tripToReturn.EndDate = tripEndDate
            tripToReturn.Members = self.invitedPeople
        } else {
            tripToReturn = Trip(name: tripName, destination: tripDestination, description: tripDescription, image: tripImage, startDate: tripStartDate, endDate: tripEndDate, fullyCreated: true, activities: [], tasks: [], members: self.invitedPeople, admins: [])
        }
        
        self.delegate?.editTripConroller(self, savedTrip: tripToReturn)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.delegate?.editTripConrollerCancelTapped(self)
    }
    
    
    // MARK: - UITableViewDataSource protocol
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(PersonTableViewCell.reuseIdentifier, forIndexPath: indexPath)
            as? PersonTableViewCell {
                
                let currentMember = people[indexPath.item]
                cell.accessoryType = self.invitedPeople[currentMember] == nil ? .None : .Checkmark
                cell.personImageView.image      = currentMember.Pic
                cell.personNameLabel.text       = "\(currentMember.FirstName) \(currentMember.LastName)"
                return cell
        }
        
        return UITableViewCell()
    }
    
//    private func indexOfInvitedPerson(person: Person) -> Int {
//        var currentIndex = 0
//        for (member, _) in self.invitedPeople {
//            if member.Id == person.Id {
//                return currentIndex
//            }
//            currentIndex++
//        }
//        return NSNotFound
//    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedMember = people[indexPath.item]
        if self.invitedPeople[selectedMember] == nil {
            // invite the person!
            invitedPeople[selectedMember] = .Pending
            numberInvitees++
        } else {
            // uninvite the person
            invitedPeople.removeValueForKey(selectedMember)
            numberInvitees--
        }
        self.tripInviteesTableView.reloadData()
        self.tripInviteesHeaderLabel.text = "Invitees (\(numberInvitees) total)"
        return
    }
    
    
    // MARK: SelectImageViewControllerDelegate protocol methods
    
    func selectImageViewController(selectImageViewController: SelectImageViewController, imageSelected: UIImage) {
        // update the button's image with the new one and dismiss dat shit
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tripImageButton.setBackgroundImage(imageSelected, forState: .Normal)
    }
    
}