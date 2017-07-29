//
//  BackgroundInfo.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/21/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

//struct BackgroundInfo {
//    var client_name: String? //
//    var client_dob: String? //
//    var client_current_city: String?
//    var client_hometown: String?
//    var client_years_homeless: String?
//    var client_contact_info: String?
//    var client_other_info: String?
//    var client_partner_org: String?
//    var recipient_name: String?
//    var recipient_relationship: String?
//    var recipient_dob: String?
//    var recipient_last_location: String?
//    var recipient_years_since_last_seen: String?
//    var recipient_other_info: String?
//    let userDefaults = UserDefaults.standard
//    
//    init(client_name: String) {
//        self.client_name = client_name
//    }
//    
//    init(defaults: UserDefaults) {
//        if let client_name = defaults.string(forKey: "client_name") {
//            self.client_name = client_name
//        } else {
//            self.client_name = ""
//        }
//        if let client_dob = defaults.string(forKey: "client_dob") {
//            self.client_dob = client_dob
//        }
//        if let client_current_city = defaults.string(forKey: "client_current_city") {
//            self.client_current_city = client_current_city
//        }
//        if let client_hometown = defaults.string(forKey: "client_hometown") {
//            self.client_hometown = client_hometown
//        }
//        if let client_years_homeless = defaults.string(forKey: "client_years_homeless") {
//            self.client_years_homeless = client_years_homeless
//        }
//        if let client_contact_info = defaults.string(forKey: "client_contact_info") {
//            self.client_contact_info = client_contact_info
//        }
//        if let client_other_info = defaults.string(forKey: "client_other_info") {
//            self.client_other_info = client_other_info
//        }
//        if let client_partner_org = defaults.string(forKey: "client_partner_org") {
//            self.client_partner_org = client_partner_org
//        }
//        if let recipient_name = defaults.string(forKey: "recipient_name")  {
//            self.recipient_name = recipient_name
//        }
//        if let recipient_relationship = defaults.string(forKey: "recipient_relationship") {
//            self.recipient_relationship = recipient_relationship
//        }
//        if let recipient_dob = defaults.string(forKey: "recipient_dob") {
//            self.recipient_dob = recipient_dob
//        }
//        if let recipient_last_location = defaults.string(forKey: "recipient_last_location") {
//            self.recipient_last_location = recipient_last_location
//        }
//        if let recipient_years_since_last_seen = defaults.string(forKey: "recipient_years_since_last_seen") {
//            self.recipient_years_since_last_seen = recipient_years_since_last_seen
//        }
//        if let recipient_other_info = defaults.string(forKey: "recipient_other_info") {
//            self.recipient_other_info = recipient_other_info
//        }
//    }
//    
//    func save() -> Void {
//        userDefaults.set(client_name, forKey: "client_name")
//        userDefaults.set(client_dob, forKey: "client_dob")
//        userDefaults.set(client_current_city, forKey: "client_current_city")
//        userDefaults.set(client_hometown, forKey: "client_hometown")
//        userDefaults.set(client_years_homeless, forKey: "client_years_homeless")
//        userDefaults.set(client_contact_info, forKey: "client_contact_info")
//        userDefaults.set(client_other_info, forKey: "client_other_info")
//        userDefaults.set(client_partner_org, forKey: "client_partner_org")
//        userDefaults.set(recipient_name, forKey: "recipient_name")
//        userDefaults.set(recipient_relationship, forKey: "recipient_relationship")
//        userDefaults.set(recipient_dob, forKey: "recipient_dob")
//        userDefaults.set(recipient_last_location, forKey: "recipient_last_location")
//        userDefaults.set(recipient_years_since_last_seen, forKey: "recipient_years_since_last_seen")
//        userDefaults.set(recipient_other_info, forKey: "recipient_other_info")
//        userDefaults.synchronize()
//    }
//    
//    static func reset() -> Void {
//        let userDefaults = UserDefaults.standard
//        userDefaults.removeObject(forKey: "client_name")
//        userDefaults.removeObject(forKey: "client_dob")
//        userDefaults.removeObject(forKey: "client_current_city")
//        userDefaults.removeObject(forKey: "client_hometown")
//        userDefaults.removeObject(forKey: "client_years_homeless")
//        userDefaults.removeObject(forKey: "client_contact_info")
//        userDefaults.removeObject(forKey: "client_other_info")
//        userDefaults.removeObject(forKey: "client_partner_org")
//        userDefaults.removeObject(forKey: "recipient_name")
//        userDefaults.removeObject(forKey: "recipient_relationship")
//        userDefaults.removeObject(forKey: "recipient_dob")
//        userDefaults.removeObject(forKey: "recipient_last_location")
//        userDefaults.removeObject(forKey: "recipient_years_since_last_seen")
//        userDefaults.removeObject(forKey: "recipient_other_info")
//        userDefaults.synchronize()
//    }
//    
//    static func upload() -> Void {
//        
//    }
//}
