//
//  LovedOne.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/13/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

class LovedOne {
    var id: String
    
    //  Public
    var firstName: String
    var middleName: String
    var relationship: String
    var age: Int
    var isAgeApproximate: Bool = false
    var lastKnownLocation: String
    var lastContact: String
    
    //  Private
    var dateOfBirth: Date
    var isDOBApproximate: Bool = false
    var notes: String
}
