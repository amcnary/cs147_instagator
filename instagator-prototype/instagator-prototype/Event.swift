//
//  Event.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class Event {
    
    var Name: String
    var Description: String
    var Cost: Float?
    var StartDate: NSDate
    var EndDate: NSDate
    
    init(name: String, description: String = "", cost: Float? = nil, startDate: NSDate, endDate: NSDate) {
        
        self.Name = name
        self.Description = description
        self.Cost = cost
        self.StartDate = startDate
        self.EndDate = endDate
    }
}