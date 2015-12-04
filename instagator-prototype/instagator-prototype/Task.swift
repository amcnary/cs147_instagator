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
    var MemberTaskStatuses: [Person: Status]
    
    var NumUsersCompleted: Int {
        return self.MemberTaskStatuses.filter({ (taskStatus: (Person, Status)) -> Bool in
            return taskStatus.1 == .Complete
        }).count
    }
    
    init(name: String, description: String, dueDate: NSDate, memberTaskStatuses: [Person: Status]) {
        self.Name = name
        self.Description = description
        self.DueDate = dueDate
        self.MemberTaskStatuses = memberTaskStatuses
    }
    
    func memberHasCompletedTask(member: Person) -> Bool {
        if let taskStatus = self.MemberTaskStatuses[member] {
            return taskStatus == .Complete
        }
        return false
    }
}