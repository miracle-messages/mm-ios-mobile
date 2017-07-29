//
//  Uploadable.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 6/25/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation
import AWSS3

protocol Uploadable {
    var awsHost: String {get}
    var bucketName: String {get}
    var name: String {get}
    var url: URL {get}
    var contentType: String {get}
    var completionBlock: AWSS3TransferUtilityUploadCompletionHandlerBlock? {get set}
    func upload() -> AWSTask<AWSS3TransferUtilityUploadTask>
}

struct Signature: Uploadable {
    var url: URL
    var name: String
    var completionBlock: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var bucketName: String
    var contentType: String
}

extension Uploadable {
    var awsHost: String {
        return "https://s3-us-west-2.amazonaws.com"
    }
    func generateHex() -> String {
        let baseIntA = Int(arc4random() % 65535)
        let baseIntB = Int(arc4random() % 65535)
        return String(format: "%06X%06X", baseIntA, baseIntB)
    }
    func upload() -> AWSTask<AWSS3TransferUtilityUploadTask> {
        let transferUtility = AWSS3TransferUtility.default()
        let transferExpression = AWSS3TransferUtilityUploadExpression()
        
        transferExpression.progressBlock = { (task, progress) in
            DispatchQueue.main.sync(execute: { () -> Void in
                print("Progress \(progress.fractionCompleted)")
            })
        }
        
        let uploadExpression = AWSS3TransferUtilityUploadExpression()
        
        uploadExpression.setValue("public-read", forRequestHeader: "x-amz-acl")
        let randomHex = generateHex()
        return transferUtility.uploadFile(url, bucket: bucketName, key: "\(randomHex)\(name)", contentType: contentType, expression: uploadExpression, completionHander: completionBlock) 
    }
}
