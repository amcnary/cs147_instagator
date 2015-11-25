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
    
    var Name: String
    var Description: String
    var DueDate: NSDate
    var UserTaskStatus: [Int:Status]
    
    init(name:String, description:String, dueDate:NSDate, userTaskStatus:[Int:Status]) {
        self.Name = name
        self.Description = description
        self.DueDate = dueDate
        self.UserTaskStatus = userTaskStatus
    }
}