//
//  Video.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/16/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

struct Video {
    let awsHost: String
    let bucketName: String
    let name: String
    let url: URL
    var videoLink: String {
        get {
            return "\(self.awsHost)/\(self.bucketName)/\(self.name)"
        }
    }

    var uniqId: String {
        get {
            randomString(length: 10)
        }
    }

    func save() -> Void {
    }

    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
