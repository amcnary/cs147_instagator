//
//  Task.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation

class Task {
    
    enum Status: String {
        case Incomplete = "Incomplete"
        case Complete = "Complete"
    }
    
    var Name: String
    var Description: String
    var DueDate: NSDate
    var MemberTaskStatus: [(member: Person, memberTaskStatus: Status)]
    
    var NumUsersCompleted: Int {
        return self.MemberTaskStatus.filter({ (taskStatus: (member: Person, memberTaskStatus: Task.Status)) -> Bool in
            return taskStatus.memberTaskStatus == .Complete
        }).count
    }
    
    init(name:String, description:String, dueDate:NSDate, memberTaskStatus: [(member: Person, memberTaskStatus: Status)]) {
        self.Name = name
        self.Description = description
        self.DueDate = dueDate
        self.MemberTaskStatus = memberTaskStatus
    }
}