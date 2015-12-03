//
//  MemberStatusViewController.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/24/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

protocol MemberStatusControllerDelegate {
    func memberChangeAdminStatusButtonTapped(memberStatusViewController: MemberStatusViewController)
    func memberRemoveFromTripButtonTapped(memberStatusViewController: MemberStatusViewController)
}

class MemberStatusViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Interface Outlets
    @IBOutlet weak var memberImageView: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberRSVPStatusLabel: UILabel!
    @IBOutlet weak var memberChangeAdminStatusButton: UIButton!
    @IBOutlet weak var memberTasksTableView: UITableView!
    @IBAction func memberChangeAdminStatusButtonTapped(sender: AnyObject) {
        self.delegate?.memberChangeAdminStatusButtonTapped(self)
        reloadUI()
        self.presentConfirmationMessage("Admin Status Changed")
    }
    
    @IBOutlet weak var memberRemoveFromTripButton: UIButton!
    @IBAction func memberRemoveFromTripButtonTapped(sender: AnyObject) {
        // alert the user that they are about to commit a dick move
        if let unwrappedMember = self.member {
            let alertController = UIAlertController(title: "Warning", message: "You are about to remove \(unwrappedMember.FirstName) from the trip. Continue?", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let continueAction = UIAlertAction(title: "Continue", style: .Default, handler: { _ in
                self.delegate?.memberRemoveFromTripButtonTapped(self)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(continueAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: Other Properties
    var member: Person?
    var trip: Trip?
    var delegate: MemberStatusControllerDelegate?
    var tripOwnershipType: TripListViewController.TripOwnershipType = .Planning
    var removeAdminString = "Remove Admin Privileges"
    var grantAdmintString = "Grant Admin Priviliges"
    
    // MARK: Lifecycle
    
    func reloadUI(){
        if let unwrappedMember = member, unwrappedTrip = trip, memberRSVPStatus = unwrappedTrip.Members[unwrappedMember] {
            self.memberImageView.image = unwrappedMember.Pic
            self.memberNameLabel.text = "\(unwrappedMember.FirstName) \(unwrappedMember.LastName)"
            
            // find and use the member's RSVP status
            if unwrappedTrip.Admins.contains(unwrappedMember){
                self.memberRSVPStatusLabel.text = "\(memberRSVPStatus.rawValue) (Admin)"
            } else {
                self.memberRSVPStatusLabel.text = memberRSVPStatus.rawValue
            }
            
            if self.tripOwnershipType == .Attending {
                self.memberChangeAdminStatusButton.hidden = true
                self.memberRemoveFromTripButton.hidden = true
            } else {
                if let unwrappedTrip = self.trip, unwrappedMember = self.member {
                    if unwrappedTrip.Admins.contains(unwrappedMember){
                        self.memberChangeAdminStatusButton.setTitle(removeAdminString, forState: .Normal)
                    } else {
                        self.memberChangeAdminStatusButton.setTitle(grantAdmintString, forState: .Normal)
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        reloadUI()
        super.viewDidLoad()
    }
    
    // MARK: UITableViewDataSource protocol
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let unwrappedTrip = self.trip, unwrappedMember = member, taskCell = tableView.dequeueReusableCellWithIdentifier(
            TaskStatusTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? TaskStatusTableViewCell {
                let currentTask = unwrappedTrip.Tasks[indexPath.row]
                taskCell.taskDueDateLabel.text = "Deadline: \(dateFormatter.stringFromDate(currentTask.DueDate))"
                taskCell.taskNameLabel.text = currentTask.Name
                if currentTask.MemberTaskStatuses[unwrappedMember] == .Complete || self.tripOwnershipType == .Attending {
                    taskCell.taskSendReminderButton.enabled = false
                }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trip?.Tasks.count ?? 0
    }
}