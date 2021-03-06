//
//  Constants.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

var userIdCounter = 0

var people: [Person] = [
    Person(firstName: "Bob",
           lastName: "Bobberson",
           pic: UIImage(named: "RandomDude")!,
           tasks: []
    ),
    Person(firstName: "Rhea",
           lastName: "Dookeran",
           pic: UIImage(named: "Rhea")!,
           tasks: []
    ),
    Person(firstName: "Amanda",
           lastName: "McNary",
           pic: UIImage(named: "Amanda")!,
           tasks: []
    ),
    Person(firstName: "Dennis",
           lastName: "Ellis",
           pic: UIImage(named: "Dennis")!,
           tasks: []
    ),
    Person(firstName: "Tanner",
           lastName: "Gilligan",
           pic: UIImage(named: "Tanner")!,
           tasks: []
    ),
    Person(firstName: "You",
        lastName: "",
        pic: UIImage(named: "Amanda")!,
        tasks: []
    ),
]

var plannedTrips: [Trip] = [
    Trip(name: "Canada",
        destination: "Ontario",
        description: "We're going to Canada!",
        image: UIImage(named: "Mountains")!,
        startDate: NSDate().dateByAddingTimeInterval(2*60*60*24),
        endDate: NSDate().dateByAddingTimeInterval(9*60*60*24),
        fullyCreated: true,
        activities: [
            Event(name: "Moose Petting",
                description: "We're gonna go pet us some Moose!",
                cost: 999.99,
                startDate: NSDate().dateByAddingTimeInterval(2.1*60*60*24),
                endDate: NSDate().dateByAddingTimeInterval(2.2*60*60*24)
            ),
            Event(name: "Hiking",
                description: "We're going to go hiking through some huge mountains. It's going to be cold, so wears warm clothes. I'm just going to keep typing things right now because I want to have a large description that can act as a stress test when presenting our trip summary.",
                cost: 100.00,
                startDate: NSDate().dateByAddingTimeInterval(2.3*60*60*24),
                endDate: NSDate().dateByAddingTimeInterval(2.4*60*60*24)
            ),
            Poll(name: "Saturday Morning",
                description: "Not sure if we want to get started with some fun stuff or eat our brains out. Braiinnssss",
                options: [
                    Event(name: "Brunch!!",
                        description: "There's a really cool place down the road from our hotel that serves bottomless mimosas",
                        cost: 80.00,
                        startDate: NSDate().dateByAddingTimeInterval(2.35*60*60*24),
                        endDate: NSDate().dateByAddingTimeInterval(2.37*60*60*24)
                    ),                    Event(name: "Hiking",
                        description: "Go check out the wilderness and stuff. Pretty strenuous.",
                        cost: 10.00,
                        startDate: NSDate().dateByAddingTimeInterval(2.35*60*60*24),
                        endDate: NSDate().dateByAddingTimeInterval(2.37*60*60*24)
                    ),
                    Event(name: "Duck Tour",
                        description: "Looking at ducks. Then shooting ducks.",
                        cost: 150.00,
                        startDate: NSDate().dateByAddingTimeInterval(2.35*60*60*24),
                        endDate: NSDate().dateByAddingTimeInterval(2.37*60*60*24)
                    )
                ],
                results: [0.90, 0.63, 0.10],
                people: [
                    people[0],
                    people[1],
                    people[2],
                    people[3]
                ],
                numPeopleResponded: 3
            )
        ],
        tasks: [
            Task(   name: "Submit deposit",
                    description: "Submit it NOW!",
                    dueDate: NSDate().dateByAddingTimeInterval(2.32*60*60*24),
                    memberTaskStatuses: [
                        people[0]: .Incomplete,
                        people[1]: .Complete,
                        people[2]: .Complete,
                        people[3]: .Incomplete
                ])
        ],
        members: [
            people[0]: .Accepted,
            people[1]: .Accepted,
            people[2]: .Accepted,
            people[3]: .Pending
        ],
        admins: [
            people[1]
        ]
    )
]

var attendingTrips: [Trip] = [
    Trip(name: "Spring Break 2016",
        destination: "Mexicoco",
        description: "Getting some spring break relaxation with mai tais and ALL the water sports",
        image: UIImage(named: "Beach")!,
        startDate: NSDate().dateByAddingTimeInterval(75*60*60*24),
        endDate: NSDate().dateByAddingTimeInterval(85*60*60*24),
        fullyCreated: true,
        activities: [
            Event(name: "Swimming",
                description: "Heard that the water is super nice",
                cost: 9.99,
                startDate: NSDate().dateByAddingTimeInterval(75.1*60*60*24),
                endDate: NSDate().dateByAddingTimeInterval(75.2*60*60*24)
            ),
            Event(name: "Island Tour",
                description: "Turns out, we'll be at an island. Mexico is an island. Or like, where we will be is anyway.",
                cost: 190.00,
                startDate: NSDate().dateByAddingTimeInterval(77.3*60*60*24),
                endDate: NSDate().dateByAddingTimeInterval(77.4*60*60*24)
            ),
            Poll(name: "Friday Afternoon",
                description: "Not sure if we want to get started with some fun stuff or eat our brains out. Braiinnssss",
                options: [
                    Event(name: "Hiking",
                        description: "Go check out the wilderness and stuff. Pretty strenuous.",
                        cost: 10.00,
                        startDate: NSDate().dateByAddingTimeInterval(76.35*60*60*24),
                        endDate: NSDate().dateByAddingTimeInterval(76.5*60*60*24)
                    ),
                    Event(name: "Brunch!!",
                        description: "Tacos and Huevos",
                        cost: 30.00,
                        startDate: NSDate().dateByAddingTimeInterval(76.4*60*60*24),
                        endDate: NSDate().dateByAddingTimeInterval(76.3*60*60*24)
                    ),
                    Event(name: "Nails and Massages",
                        description: "Spa day because we gotta treat yo self.",
                        cost: 150.00,
                        startDate: NSDate().dateByAddingTimeInterval(76.35*60*60*24),
                        endDate: NSDate().dateByAddingTimeInterval(76.55*60*60*24)
                    )
                ],
                results: [0.90, 0.63, 0.10],
                people: [
                    people[5],
                    people[3],
                    people[1],
                    people[4]
                ],
                numPeopleResponded: 3
            )
        ],
        tasks: [
            Task(   name: "Submit deposit",
                description: "You have to submit it NOW",
                dueDate: NSDate().dateByAddingTimeInterval(22.32*60*60*24),
                memberTaskStatuses: [
                    people[5]: .Complete,
                    people[3]: .Incomplete,
                    people[1]: .Complete,
                    people[4]: .Incomplete
                ]),
            Task(   name: "Passport Photocopy",
                description: "Submit yo shiite right meow",
                dueDate: NSDate().dateByAddingTimeInterval(26.32*60*60*24),
                memberTaskStatuses: [
                    people[5]: .Incomplete,
                    people[3]: .Incomplete,
                    people[1]: .Complete,
                    people[4]: .Incomplete
                ])
        ],
        members: [
            people[5]: .Accepted,
            people[3]: .Accepted,
            people[1]: .Accepted,
            people[4]: .Pending
        ],
        admins: [
            people[1]
        ]
    )
]

var dateFormatter: NSDateFormatter {
    let formatter           = NSDateFormatter()
    formatter.dateFormat    = "EEE. MMM dd"
    formatter.locale        = NSLocale(localeIdentifier: "en_US")
    return formatter
}

var dateTimeFormatter: NSDateFormatter {
    let formatter           = NSDateFormatter()
    formatter.dateFormat    = "MMM dd (H:MM)"
    formatter.locale        = NSLocale(localeIdentifier: "en_US")
    return formatter
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }
}

extension UIViewController {
    func presentConfirmationMessage(message: String) {
        let confirmationMessageAlertController = UIAlertController(title: "Message",
            message: message, preferredStyle: .Alert)
        let continueAction = UIAlertAction(title: "Thanks!", style: .Default, handler: nil)
        confirmationMessageAlertController.addAction(continueAction)
        self.presentViewController(confirmationMessageAlertController, animated: true, completion: nil)
    }
}


















