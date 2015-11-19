//
//  ActivityTableViewCell.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/18/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    // MARK: constants
    
    static let reuseIdentifier = "ActivityTableViewCell"
    
    
    // MARK: - interface outlets
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    @IBOutlet weak var activityPollStatusLabel: UILabel!
    @IBOutlet weak var viewResultsButton: UIButton!
    
}