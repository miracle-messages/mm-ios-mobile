//
//  Config.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 10/14/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation


struct Config {
    static let baseUrl = Bundle.main.infoDictionary?["BASE_URL"] as! String
    static let registerUrl = Bundle.main.infoDictionary?["REGISTER_URL"] as! String
    static let firebaseConfigFileName = Bundle.main.infoDictionary?["FIREBASE"] as! String
}

