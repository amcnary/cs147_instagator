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
    )
]

var trips: [Trip] = [
    Trip(name: "Canada",
        destination: "Ontario",
        description: "We're going to Canada!",
        image: UIImage(named: "CanadaImage")!,
        startDate: NSDate().dateByAddingTimeInterval(2*60*60*24),
        endDate: NSDate().dateByAddingTimeInterval(9*60*60*24),
        fullyCreated: true,
        events: [
            Event(name: "Moose Petting",
                description: "We're gonna go pet us some Moose!",
                pic: UIImage(named: "Moose")!,
                cost: 999.99,
                startDate: NSDate().dateByAddingTimeInterval(2.1*60*60*24),
                endDate: NSDate().dateByAddingTimeInterval(2.2*60*60*24)
            ),
            Event(name: "Hiking",
                description: "We're going to go hiking through some huge mountains. It's going to be cold, so wears warm clothes. I'm just going to keep typing things right now because I want to have a large description that can act as a stress test when presenting our trip summary.",
                pic: UIImage(named: "Hiking")!,
                cost: 100.00,
                startDate: NSDate().dateByAddingTimeInterval(2.3*60*60*24),
                endDate: NSDate().dateByAddingTimeInterval(2.4*60*60*24)
            ),
            Event(name: "Saturday Morning",
                description: "Debating between brunch, board games, and water sports. Not sure what you guys are up for!",
                pic: UIImage(named: "Mountains")!,
                cost: 150.00,
                startDate: NSDate().dateByAddingTimeInterval(2.35*60*60*24),
                endDate: NSDate().dateByAddingTimeInterval(2.37*60*60*24),
                poll: Poll( name: "Yup I'mma poll",
                            description: "IDK, this is just filler for now"
                        )
            ),
        ],
        polls: [
            Poll(name: "Poll 1",
                 description: "IDK, this is just filler for now"
            )
        ],
        tasks: [
            Task(description: "Submit deposit", dueDate: NSDate(), userTaskStatus: [:])
        ],
        members: [
            (people[0], .Accepted),
            (people[1], .Accepted),
            (people[2], .Accepted),
            (people[4], .Pending)
        ],
        admins: [
            people[3]
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
    formatter.dateFormat    = "EEE. MMM (HH:MM)"
    formatter.locale        = NSLocale(localeIdentifier: "en_US")
    return formatter
}




