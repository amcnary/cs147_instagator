//
//  ActivityTableViewCell.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/18/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol ActivityTableViewCellDelegate {
    func activityTableViewCell(activityTableViewCell: ActivityTableViewCell,
        viewPollResultsTappedAtIndexPath indexPath: NSIndexPath)
}

class ActivityTableViewCell: UITableViewCell {
    
    // MARK: constants
    
    static let reuseIdentifier = "ActivityTableViewCell"
    
    
    // MARK: - interface outlets
    
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    @IBOutlet weak var activityPollStatusLabel: UILabel!
    @IBOutlet weak var viewResultsButton: UIButton!
    
    
    // MARK: - other properties
    
    var delegate: ActivityTableViewCellDelegate?
    var indexPath: NSIndexPath?
    
    
    // MARK: interface actions
    
    @IBAction func viewPollResultsButtonTapped(sender: UIButton) {
        if let unwrappedIndexPath = self.indexPath, unwrappedDelegate = self.delegate {
            unwrappedDelegate.activityTableViewCell(self, viewPollResultsTappedAtIndexPath: unwrappedIndexPath)
        }
    }
}