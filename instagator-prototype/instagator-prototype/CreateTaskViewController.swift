//
//  CreateTaskViewController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class CreateTaskViewController: UIViewController {
    // MARK: Interface Outlets
    @IBOutlet weak var taskNameTextView: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskDueDatePicker: UIDatePicker!
}