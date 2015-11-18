//
//  Task.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation

class Task {
    
    enum Status {
        case NotStarted
        case Started
        case Completed
    }
    
    var Description: String
    var DueDate: NSDate
    var UserTaskStatus: [String:Status]
    
    init(description:String, dueDate:NSDate, userTaskStatus:[String:Status]) {
        self.Description = description
        self.DueDate = dueDate
        self.UserTaskStatus = userTaskStatus
    }
}