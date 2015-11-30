//
//  CreateActivityViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/24/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit  


class CreateActivityViewController: UIViewController {
    
    // MARK: Interface Outlets
    
    @IBOutlet weak var activityNameTextField: UITextField!
    @IBOutlet weak var activityStartDatePicker: UIDatePicker!
    @IBOutlet weak var activityEndDatePicker: UIDatePicker!
    @IBOutlet weak var activityDescriptionTextView: UITextView!
    @IBOutlet weak var activityProjectedCostTextField: UITextField!
    
    // MARK: other variables
    
    var activity: Event?
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        if let unwrappedActivity = activity {
            self.activityNameTextField.text = unwrappedActivity.Name
            self.activityStartDatePicker.date = unwrappedActivity.StartDate
            self.activityEndDatePicker.date = unwrappedActivity.EndDate
            self.activityDescriptionTextView.text = unwrappedActivity.Description
            self.activityProjectedCostTextField.text = "$\(unwrappedActivity.Cost)"
        }
    }
}