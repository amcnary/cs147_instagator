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
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    
    
    // MARK: other variables
    
    var event: Event?
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        if let unwrappedEvent = event {
            self.activityNameTextField.text = unwrappedEvent.Name
            self.activityStartDatePicker.date = unwrappedEvent.StartDate
            self.activityEndDatePicker.date = unwrappedEvent.EndDate
            self.activityDescriptionTextView.text = unwrappedEvent.Description
            if let eventCost = unwrappedEvent.Cost {
                self.activityProjectedCostTextField.text = "\(eventCost)"
            }
            self.navigationBarItem.title = "Edit Event"
        }
        super.viewDidLoad()
    }
}