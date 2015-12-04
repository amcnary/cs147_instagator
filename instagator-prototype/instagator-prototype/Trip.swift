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
    
    var FullyCreated: Bool
    var Activities: [Activity]
    var Tasks: [Task]
    
    var Members: [Person: RSVPStatus]
    var Admins: Set<Person>
    
    init(name: String, destination: String, description: String, image: UIImage, startDate: NSDate, endDate: NSDate,
        fullyCreated: Bool, activities: [Activity], tasks: [Task], members: [Person: RSVPStatus],
        admins: Set<Person>) {
            
            self.Name = name
            self.Destination = destination
            self.Description = description
            self.Image = image
            
            self.CreationDate = NSDate()
            self.StartDate = startDate
            self.EndDate = endDate
            
            self.FullyCreated = fullyCreated
            self.Activities = activities
            self.Tasks = tasks
            
            self.Members = members
            self.Admins = admins
    }
    
    func numTasksCompletedByMember(member: Person) -> Int {
        var numTasksCompleted = 0
        for task in self.Tasks {
            if task.memberHasCompletedTask(member) {
                numTasksCompleted++
            }
        }
        return numTasksCompleted
    }
}
