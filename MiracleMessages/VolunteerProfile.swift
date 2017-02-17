//
//  VolunteerProfile.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/16/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

struct VolunteerProfile {
    var name: String?
    var email: String?
    var phone: String?
    var location: String?

    init(defaults: UserDefaults) {
        if let name = defaults.string(forKey: "name") {
            self.name = name
        }
        if let email = defaults.string(forKey: "email") {
            self.email = email
        }
        if let phone = defaults.string(forKey: "phone") {
            self.phone = phone
        }
        if let location = defaults.string(forKey: "location") {
            self.location = location
        }
    }

    init(name: String, email: String, phone: String, location: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.location = location
    }

    func save() -> Void {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: "name")
        defaults.set(email, forKey: "email")
        defaults.set(phone, forKey: "phone")
        defaults.set(location, forKey: "location")
        defaults.synchronize()
    }
}
