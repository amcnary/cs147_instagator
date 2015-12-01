//
//  Poll.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation

class Poll: Activity {
    var Name: String
    var Description: String
    var Options: [Event]
    var Results: [Double]
    var People: [Person]
    
    init(name: String, description: String, options: [Event], results: [Double], people: [Person]) {
        self.Name = name
        self.Description = description
        self.Options = options
        self.Results = results
        self.People = people
    }
}