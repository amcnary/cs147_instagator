//
//  TripSummaryViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class TripSummaryViewController: UIViewController {
    
    // MARK: interface outlets

    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripDestinationLabel: UILabel!
    @IBOutlet weak var tripDatesLabel: UILabel!
    @IBOutlet weak var tripDescriptionLabel: UILabel!
    @IBOutlet weak var inviteesHeaderLabel: UILabel!
    @IBOutlet weak var tripInviteesCollectionView: UICollectionView!
    @IBOutlet weak var tripActivitiesTableView: UITableView!
    @IBOutlet weak var tripTasksTableView: UITableView!
    

    // MARK: properties
    
    var trip: Trip?
    
    // MARK: lifecycle
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let id = segue.identifier, editViewController = segue.destinationViewController as? EditTripViewController where id == "SummaryToEditSegue" {
            editViewController.trip = self.trip
        }
    }
    
}