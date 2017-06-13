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
    
    var current: Source { return Source(platform: "iOS", version: Bundle.main.value(forKey: "CFBundleShortVersionString")) }
}
