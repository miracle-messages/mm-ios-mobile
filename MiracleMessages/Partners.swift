//
//  Partners.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 8/9/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class Partners {
    static let instance = Partners()
    
    var list = [String]()
    
    private init() {
        //  TODO: Populate with Firebase call
        list = ["MSC", "Downtown Streets Team", "Mission Navigation Center"]
    }
}
