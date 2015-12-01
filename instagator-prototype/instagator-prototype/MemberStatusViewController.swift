//
//  MemberStatusViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/24/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit


class MemberStatusViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Interface Outlets
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberRSVPStatusLabel: UILabel!
    @IBOutlet weak var memberChangeAdminStatusButton: UIButton!
    @IBOutlet weak var memberTasksTableView: UITableView!
    
    // MARK: Other Properties
    
    var member: Person?
    var trip: Trip?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        if let unwrappedMember = member, unwrappedTrip = trip {
            self.memberImageView.image = unwrappedMember.Pic
            self.memberNameLabel.text = "\(unwrappedMember.FirstName) \(unwrappedMember.LastName)"
            
            // find and use the member's RSVP status
//            let memberIndex = indexOfPerson(unwrappedMember)
//            if memberIndex != NSNotFound {
                self.memberRSVPStatusLabel.text = unwrappedTrip.Members[unwrappedMember]?.rawValue
//            }
        }
        super.viewDidLoad()
    }

//    private func indexOfPerson(person: Person) -> Int {
//        if let unwrappedTrip = self.trip {
//            var currentIndex = 0
//            for (member, _) in unwrappedTrip.Members {
//                if member.Id == person.Id {
//                    return currentIndex
//                }
//                currentIndex++
//            }
//        }
//        return NSNotFound
//    }
    
    // MARK: UITableViewDataSource protocol
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let unwrappedTrip = self.trip, unwrappedMember = member, taskCell = tableView.dequeueReusableCellWithIdentifier(
            TaskStatusTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? TaskStatusTableViewCell {
                let currentTask = unwrappedTrip.Tasks[indexPath.row]
                taskCell.taskDueDateLabel.text = "Deadline: \(dateFormatter.stringFromDate(currentTask.DueDate))"
                taskCell.taskNameLabel.text = currentTask.Name
//                let memberIndex = indexOfPerson(unwrappedMember)
                if currentTask.MemberTaskStatuses[unwrappedMember] == .Complete {
                    taskCell.taskSendReminderButton.enabled = false
                }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trip?.Tasks.count ?? 0
    }
}