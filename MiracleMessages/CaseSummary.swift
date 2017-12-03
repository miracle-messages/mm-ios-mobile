//
//  CaseSummary.swift
//  MiracleMessages
//
//  Created by Win Raguini on 7/31/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation


struct CaseSummary {
    let name: String
    let imageUrl: String
    let key: String

    var caseURL: String {
        return "https://my.miraclemessages.org/#!/cases/\(key)"
    }
}
