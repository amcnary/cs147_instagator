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
    
    var trip: Trip?
    var delegate: EditTripViewControllerDelegate?
    
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripImageButton: UIButton!
    @IBOutlet weak var tripDestinationTextField: UITextField!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var tripStartDatePicker: UIDatePicker!
    @IBOutlet weak var tripEndDatePicker: UIDatePicker!
    @IBOutlet weak var tripInviteesHeaderLabel: UILabel!
    @IBOutlet weak var tripInviteesTableView: UITableView!
    
    override func viewDidLoad() {
        if let unwrappedTrip = self.trip {
            self.tripNameTextField.text = unwrappedTrip.Name
            self.tripDestinationTextField.text = unwrappedTrip.Destination
            self.tripDescriptionTextView.text = unwrappedTrip.Description
            self.tripImageButton.setBackgroundImage(unwrappedTrip.Image, forState: .Normal)
            self.tripImageButton.setTitle(nil, forState: .Normal)
            self.tripStartDatePicker.setDate(unwrappedTrip.StartDate, animated: false)
            self.tripEndDatePicker.setDate(unwrappedTrip.EndDate, animated: false)
            self.tripInviteesHeaderLabel.text = "Invitees (\(unwrappedTrip.Members.count) total)"
        }
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
        let tripDescription = self.tripDescriptionTextView.text ?? ""
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
        } else {
            tripToReturn = Trip(name: tripName, destination: tripDestination, description: tripDescription, image: tripImage, startDate: tripStartDate, endDate: tripEndDate, fullyCreated: true, events: [], polls: [], tasks: [], members: [], admins: [])
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
            
                let invitedUsers = self.trip?.Members ?? []
                let currentMember = people[indexPath.item]
                cell.personImageView.image      = currentMember.Pic
                cell.personNameLabel.text       = "\(currentMember.FirstName) \(currentMember.LastName)"
                return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    
    // MARK: SelectImageViewControllerDelegate protocol methods
    
    func selectImageViewController(selectImageViewController: SelectImageViewController, imageSelected: UIImage) {
        // update the button's image with the new one and dismiss dat shit
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tripImageButton.setBackgroundImage(imageSelected, forState: .Normal)
    }
    
}