//
//  Source.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/13/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

struct Source {
    let platform: String
    let version: String
    
    static var current: Source {        
        return Source(platform: "iOS", version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "nil")
    }
    
    var dictionary: [String: String] {
        return ["platform": platform, "version": version]
    }
}
