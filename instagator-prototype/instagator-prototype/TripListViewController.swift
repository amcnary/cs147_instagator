//
//  TripListViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class TripListViewController: UICollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            TripCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as? TripCollectionViewCell {
                
                let currentTrip                 = trips[indexPath.item]
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
        return trips.count
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tripSummaryViewController = storyboard.instantiateViewControllerWithIdentifier(TripSummaryViewController.storyboardId) as? TripSummaryViewController {
            
                tripSummaryViewController.trip = trips[indexPath.item]
                self.navigationController?.pushViewController(tripSummaryViewController, animated: true)
        }
        
        return
    }
}