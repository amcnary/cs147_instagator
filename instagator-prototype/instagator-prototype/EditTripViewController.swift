//
//  EditTripViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class EditTripViewController: UIViewController, UINavigationBarDelegate {
    
    var trip: Trip?
    
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
            self.tripStartDatePicker.setDate(unwrappedTrip.StartDate, animated: false)
            self.tripEndDatePicker.setDate(unwrappedTrip.EndDate, animated: false)
            self.tripInviteesHeaderLabel.text = "Invitees (\(unwrappedTrip.Members.count) total)"
        }
    }
    
}