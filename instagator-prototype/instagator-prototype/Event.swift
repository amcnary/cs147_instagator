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
    var Pic: UIImage?
    var Cost: Float?
    var StartDate: NSDate
    var EndDate: NSDate
    var EventPoll: Poll?
    
    init(name: String, description: String = "", pic: UIImage, cost: Float? = nil, startDate: NSDate, endDate: NSDate, poll: Poll? = nil) {
        
        self.Name = name
        self.Description = description
        self.Pic = pic
        self.Cost = cost
        self.StartDate = startDate
        self.EndDate = endDate
        self.EventPoll = poll
    }
}