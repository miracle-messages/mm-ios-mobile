//
//  Partners.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 8/9/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import Firebase

class Partners {
    static let instance = Partners()

    var list: [String] {
        var array = Array(dictionary.keys).sorted()
        array.append(Partners.other)
        array.append("N/A")
        return array }
    
    private var dictionary = [String: String]()
    private static let other = "Other (see notes)"

    private init() {
        //  TODO: Populate with Firebase call
        let partnersReference = Database.database().reference().child("partners")
        
        partnersReference.observe(.value, with: { snapshot in
            guard let children = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for item in children {
                guard item.hasChild("name"), item.hasChild("code") else { continue }
                guard let name = item.childSnapshot(forPath: "name").value as? String,
                    let code = item.childSnapshot(forPath: "code").value as? String else { continue }
                self.dictionary[name] = code
            }
        })
    }
    
    subscript(_ key: String) -> String? {
        if key == Partners.other { return "other"
        } else { return dictionary[key] }
    }
}
