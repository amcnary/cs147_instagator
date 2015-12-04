//
//  CreateActivityViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/24/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit  

protocol CreateActivityViewControllerDelegate {
    func createActivityControllerSaveTapped(createActivityController: CreateActivityViewController, savedEvent event: Event)
}

class CreateActivityViewController: UIViewController {
    
    // MARK: Interface Outlets
    
    @IBOutlet weak var activityNameTextField: UITextField!
    @IBOutlet weak var activityStartDatePicker: UIDatePicker!
    @IBOutlet weak var activityEndDatePicker: UIDatePicker!
    @IBOutlet weak var activityDescriptionTextView: UITextView!
    @IBOutlet weak var activityProjectedCostTextField: UITextField!
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    
    
    // MARK: other variables
    var trip: Trip?
    var event: Event?
    var delegate: CreateActivityViewControllerDelegate?
    var tripOwnershipType: TripListViewController.TripOwnershipType = .Planning

    // MARK: lifecycle
    
    override func viewDidLoad() {
        if let unwrappedEvent = event, unwrappedTrip = self.trip {
            self.activityNameTextField.text = unwrappedEvent.Name
            
            // set date stuff
            self.activityStartDatePicker.date = unwrappedEvent.StartDate
            self.activityEndDatePicker.date = unwrappedEvent.EndDate
            self.activityStartDatePicker.minimumDate = unwrappedTrip.StartDate
            self.activityEndDatePicker.minimumDate = unwrappedTrip.StartDate
            self.activityStartDatePicker.maximumDate = unwrappedTrip.EndDate
            self.activityEndDatePicker.maximumDate = unwrappedTrip.EndDate
            self.activityDescriptionTextView.text = unwrappedEvent.Description
            if let eventCost = unwrappedEvent.Cost {
                self.activityProjectedCostTextField.text = "\(eventCost)"
            }

            if self.tripOwnershipType == .Attending {
                self.navigationBarItem.rightBarButtonItems = nil
                self.navigationBarItem.title = "View Event"
                self.activityNameTextField.userInteractionEnabled = false
                self.activityDescriptionTextView.userInteractionEnabled = false
                self.activityStartDatePicker.userInteractionEnabled = false
                self.activityEndDatePicker.userInteractionEnabled = false
                self.activityProjectedCostTextField.userInteractionEnabled = false
            } else {
                self.navigationBarItem.title = "Edit Event"
            }
        } else {
            self.navigationBarItem.title = "Create Event"
        }
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Form Error", message: "", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alertController.addAction(confirmAction)
        
        guard let eventName = self.activityNameTextField.text where eventName != "Activity Name" && eventName != "" else {
            alertController.message = "You must include an event name!"
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        let eventDescription = (self.activityDescriptionTextView.text != "Activity description (optional)") ? self.activityDescriptionTextView.text : ""
        let eventCost = (self.activityProjectedCostTextField.text != "Projected Cost (optional)") ? self.activityDescriptionTextView.text : ""
        let startDate = self.activityStartDatePicker.date
        let endDate = self.activityEndDatePicker.date
        
        let eventToReturn: Event = Event(name: eventName, description: eventDescription, cost: Float(eventCost), startDate: startDate, endDate: endDate)
        self.delegate?.createActivityControllerSaveTapped(self, savedEvent: eventToReturn)
    }
}