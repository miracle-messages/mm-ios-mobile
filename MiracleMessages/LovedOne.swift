//
//  LovedOne.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/13/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

class LovedOne {
    var id: String?
    
    //  Public
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var relationship: String?
    var lastKnownLocation: String?
    var lastContact: String?
    
    var publicInfo: [String: Any] {
        var info = [String: Any]()
        if let firstName = firstName { info["firstName"] = firstName }
        if let middleName = middleName { info["middleName"] = middleName }
        if let lastName = lastName { info["lastName"] = lastName }
        if let relationship = relationship { info["relationship"] = relationship }
        if let lastKnownLocation = lastKnownLocation { info["lastKnownLocation"] = lastKnownLocation }
        if let lastContact = lastContact { info["lastContact"] = lastContact }
        if let dob = dateOfBirth, let age = Calendar.current.dateComponents([.year], from: dob, to: Date()).year { info["age"] = age }
        info["ageAppoximate"] = isDOBApproximate
        return info
    }
    
    //  Private
    var dateOfBirth: Date?
    var isDOBApproximate: Bool = false
    var notes: String?
    
    var privateInfo: [String: Any] {
        var info = [String: Any]()
        if let dateOfBirth = dateOfBirth { info["dob"] = DateFormatter.default.string(from: dateOfBirth) }
        info["dobApproximate"] = isDOBApproximate
        return info
    }
}
