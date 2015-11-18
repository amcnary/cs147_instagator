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
    
    var Name: String
    var Description: String
    var Image: UIImage
    
    var CreationDate: NSDate
    var StartDate: NSDate
    var EndDate: NSDate
    
    var FullyCreated: Bool = false
    var Events: [Event] = []
    var Polls: [Poll] = []
    
    var Members: [Person] = []
    var Admins: [Person] = []
    
    init(name:String, description:String, image:UIImage, startDate:NSDate, endDate:NSDate, fullyCreated:Bool, events:[Event], polls:[Poll], members:[Person], admins:[Person]) {
            
            self.Name = name
            self.Description = description
            self.Image = image
            
            self.CreationDate = NSDate()
            self.StartDate = startDate
            self.EndDate = endDate
            
            self.FullyCreated = fullyCreated
            self.Events = events
            self.Polls = polls
            
            self.Members = members
            self.Admins = admins
    }
}
