//
//  LovedOne.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/13/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

class LovedOne: Hashable {
    static var count = 0
    static func getNextHash() -> Int {
        let hash = count
        count += 1
        return hash
    }
    
    var id: String?
    
    //  Public
    var firstName: String?
    var middleName: String?
    var lastName: String?
    var relationship: String?
    var lastKnownLocation: String?
    var lastContact: String?
    var age: Int?
    var isAgeApproximate: Bool = false
    
    lazy var hashValue: Int = self.id?.hashValue ?? LovedOne.getNextHash()
    
    var fullName: String {
        var this = ""
        if let bit = firstName, bit != "" { this += bit + " " }
        if let bit = middleName, bit != "" { this += bit + " " }
        if let bit = lastName { this += bit }
        return this
    }
    
    var reviewDescription: String {
        var this = ""
        
        if let relationship = relationship { this += "Relationship: \(relationship)" }
        
        if let birthdate = dateOfBirth {
            let dateFormatter: DateFormatter = {
                let this = DateFormatter()
                this.dateStyle = .long
                this.timeStyle = .none
                return this
            }()
            this += "Date of birth: \(dateFormatter.string(from: birthdate))\n" }
        
        if let age = age { this += "Age: \(age)\n" }
        
        if let location = lastKnownLocation { this += "Location: \(location)\n" }
        
        if let timeApart = lastContact { this += "Last contact: \(timeApart)\n" }
        
        if let notes = notes { this += "Other info: \(notes)" }
        
        return this
    }
    
    var publicInfo: [String: Any] {
        var info = [String: Any]()
        if let firstName = firstName { info["firstName"] = firstName }
        if let middleName = middleName { info["middleName"] = middleName }
        if let lastName = lastName { info["lastName"] = lastName }
        if let relationship = relationship { info["relationship"] = relationship }
        if let lastKnownLocation = lastKnownLocation { info["lastKnownLocation"] = lastKnownLocation }
        if let lastContact = lastContact { info["lastContact"] = lastContact }
        if let age = age { info["age"] = age }
        info["ageAppoximate"] = isAgeApproximate
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
    
    static func ==(a: LovedOne, another: LovedOne) -> Bool {
        return a.hashValue == another.hashValue
    }
}
