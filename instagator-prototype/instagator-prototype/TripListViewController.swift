//
//  TripListViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class TripListViewController: UICollectionViewController, EditTripViewControllerDelegate, TripSummaryViewControllerDelegate {
    
    enum TripOwnershipType {
        case Planning
        case Attending
    }
    
    // MARK: constants
    
    static let pushCreateTripSegueIdentifier = "PushCreateTripSegue"
    
    
    // MARK: interface outlets
    
    @IBOutlet weak var navigationBarItem: UINavigationItem!
    
    
    // MARK: other properties
    
    var tripOwnershipType: TripOwnershipType = .Planning
    var selectedIndex: NSIndexPath?
    
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        let navigationBarTitle: String
        switch self.tripOwnershipType {
        case .Planning:
            navigationBarTitle = "Trips I'm Planning"
        case .Attending:
            navigationBarTitle = "Trips I'm Attending"
            self.navigationBarItem.rightBarButtonItems = nil
        }
        self.navigationBarItem.title = navigationBarTitle
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let id = segue.identifier, editViewController = segue.destinationViewController as? EditTripViewController
            where id == TripListViewController.pushCreateTripSegueIdentifier {
                editViewController.delegate = self
        }
    }
    
    
    // MARK: UICollecionViewDataSource protocol methods
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TripCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? TripCollectionViewCell {
                
                let currentTrip: Trip
                switch self.tripOwnershipType {
                case .Planning:
                    currentTrip = plannedTrips[indexPath.item]
                case .Attending:
                    currentTrip = attendingTrips[indexPath.item]
                }
                cell.tripNameLabel.text         = currentTrip.Name
                cell.tripStatusLabel.text       = currentTrip.FullyCreated ? "" : "Saved"
                let startDateString             = dateFormatter.stringFromDate(currentTrip.StartDate)
                let endDateString               = dateFormatter.stringFromDate(currentTrip.EndDate)
                cell.tripDatesLabel.text        = "\(startDateString) to \(endDateString)"
                cell.tripImageView.image        = currentTrip.Image
                cell.tripDestinationLabel.text  = currentTrip.Destination
                
                return cell
        }
        
        return UICollectionViewCell()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.tripOwnershipType {
        case .Planning:
            return plannedTrips.count
        case .Attending:
            return attendingTrips.count
        }
    }
    
    // MARK: UICollecionViewDelegate protocol methods
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tripSummaryViewController = storyboard.instantiateViewControllerWithIdentifier(
            TripSummaryViewController.storyboardId) as? TripSummaryViewController {
            
                let currentTrip: Trip
                self.selectedIndex = indexPath
                switch self.tripOwnershipType {
                case .Planning:
                    currentTrip = plannedTrips[indexPath.item]
                case .Attending:
                    currentTrip = attendingTrips[indexPath.item]
                }
                tripSummaryViewController.trip = currentTrip
                tripSummaryViewController.delegate = self
                tripSummaryViewController.tripOwnershipType = self.tripOwnershipType
                self.navigationController?.pushViewController(tripSummaryViewController, animated: true)
        }
        
        return
    }
    
    
    // MARK: EditTripViewControllerDelegate protocol methods
    
    func editTripConrollerCancelTapped(editTripController: EditTripViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editTripConroller(editTripController: EditTripViewController, savedTrip trip: Trip) {
        self.dismissViewControllerAnimated(true, completion: nil)
        plannedTrips.append(trip)
        collectionView?.reloadData()
    }
    
    
    // MARK: TripSummaryViewControllerDelegate protocol methods
    
    func tripSummaryViewControllerEditedTrip(tripSummaryViewController: TripSummaryViewController) {
        self.collectionView?.reloadData()
    }
    
    func tripSummaryRemovePlannedTripPressed(tripSummaryViewController: TripSummaryViewController) {
        self.navigationController?.popViewControllerAnimated(true)
        if let indexPath = self.selectedIndex {
            plannedTrips.removeAtIndex(indexPath.item)
            self.collectionView?.reloadData()
        }
        selectedIndex = nil
        return
    }
    func tripSummaryRemoveAttendingTripPressed(tripSummaryViewController: TripSummaryViewController) {
        self.navigationController?.popViewControllerAnimated(true)
        if let indexPath = self.selectedIndex {
            attendingTrips.removeAtIndex(indexPath.item)
            self.collectionView?.reloadData()
        }
        selectedIndex = nil
        return
    }

}