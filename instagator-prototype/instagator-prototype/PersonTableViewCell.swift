//
//  PersonTableViewCell.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 11/18/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class PersonTableViewCell: UITableViewCell {
    
    // MARK: - constants
    
    static let reuseIdentifier = "PersonTableViewCell"
    
    // MARK: - interface outlets
    
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    
}