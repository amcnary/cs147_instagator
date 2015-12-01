//
//  TabNavigationController.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 12/1/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class PlannedTripListNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        if let tripListViewController = self.viewControllers[0] as? TripListViewController {
            tripListViewController.tripOwnershipType = .Planning
        }
        super.viewDidLoad()
    }
}

class AttendingTripListNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        if let tripListViewController = self.viewControllers[0] as? TripListViewController {
            tripListViewController.tripOwnershipType = .Attending
        }
        super.viewDidLoad()
    }
}