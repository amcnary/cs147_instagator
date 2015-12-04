//
//  PendingPoll.swift
//  instagator-prototype
//
//  Created by Amanda McNary on 12/3/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation

class PendingPoll: Activity {
    
    var Name: String
    var Description: String
    
    init(name: String, description: String = "") {
        self.Name = name
        self.Description = description
    }
}