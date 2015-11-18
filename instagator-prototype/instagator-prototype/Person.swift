//
//  Person.swift
//  instagator-prototype
//
//  Created by Tanner Gilligan on 11/17/15.
//  Copyright © 2015 ThePenguins. All rights reserved.
//

import Foundation
import UIKit

class Person {
    var FirstName: String
    var LastName: String
    var Pic: UIImage
    var Tasks: [Task] = []
    var Id: Int
    
    init(firstName:String, lastName:String, pic:UIImage, tasks:[Task]) {
        self.FirstName = firstName
        self.LastName = lastName
        self.Pic = pic
        self.Tasks = tasks
        self.Id = userIdCounter
        userIdCounter++
    }
}
