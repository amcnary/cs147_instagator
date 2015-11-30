//
//  Trip.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class Trip: NSObject {
    enum RSVPStatus: String {
        case Pending = "Pending"
        case Accepted = "Accepted"
        case Maybe = "Maybe"
    }
    
    var Name: String
    var Description: String
    var Destination: String
    var Image: UIImage
    
    var CreationDate: NSDate
    var StartDate: NSDate
    var EndDate: NSDate
    
    var FullyCreated: Bool = false
    var Events: [Event] = []
    var Polls: [Poll] = []
    var Tasks:  [Task] = []
    
    var Members: [(member: Person, memberRSVPStatus: RSVPStatus)] = []
    var Admins: [Person] = []
    
    init(name: String, destination: String, description: String, image: UIImage, startDate: NSDate, endDate: NSDate,
        fullyCreated: Bool, events: [Event], polls: [Poll], tasks: [Task], members: [(member: Person, memberRSVPStatus: RSVPStatus)],
        admins: [Person]) {
            
            self.Name = name
            self.Destination = destination
            self.Description = description
            self.Image = image
            
            self.CreationDate = NSDate()
            self.StartDate = startDate
            self.EndDate = endDate
            
            self.FullyCreated = fullyCreated
            self.Events = events
            self.Polls = polls
            self.Tasks = tasks
            
            self.Members = members
            self.Admins = admins
    }
}
