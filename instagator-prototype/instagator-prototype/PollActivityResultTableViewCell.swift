//
//  PollActivityResultTableViewCell.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/29/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class PollActivityResultTableViewCell: UITableViewCell {
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activitySatisfactionLabel: UILabel!
    
    static let reuseIdentifier = "PollActivityResultTableViewCell"
}