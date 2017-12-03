//
//  Video.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/16/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation
import AWSS3

struct Video: Uploadable {

    var contentType: String

    var completionBlock: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    let awsHost: String
    let bucketName: String
    let name: String
    let url: URL
    var videoLink: String {
        get {
            return "\(self.awsHost)/\(self.bucketName)/\(self.name)"
        }
    }
}
