//
//  DateFormatterExtension.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/21/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(forFormat format: String) {
        self.init()
        dateFormat = format
    }
    
    static var `default`: DateFormatter { return DateFormatter(forFormat: "MM/dd/yy") }
}
