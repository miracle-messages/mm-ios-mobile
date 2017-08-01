//
//  ConfirmViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import AWSS3
import FirebaseDatabase
import Alamofire
import FirebaseStorage
struct Keys {
    static let caseID = "caseID"
}

class ConfirmViewController: UIViewController {

    var video: Video?
    var ref: DatabaseReference!
    let currentCase: Case = Case.current
    let zapierUrl = "https://hooks.zapier.com/hooks/catch/1838547/hshdv5/"
    let storage = Storage.storage()

    //"https://hooks.zapier.com/hooks/catch/1838547/tsx0t0/"
    //https://hooks.zapier.com/hooks/catch/1838547/hshdv5/

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.navigationItem.backBarButtonItem?.title = "test"
    }

    func bgUploadToS3(video: Video) -> Void {
//        Logger.log("bgUploadToS3: url:\(video.url.absoluteString), name:\(video.name), bucket:\(video.bucketName)")
//        let transferUtility = AWSS3TransferUtility.default()
//        let transferExpression = AWSS3TransferUtilityUploadExpression()
//
//        transferExpression.progressBlock = { (task, progress) in
//            DispatchQueue.main.sync(execute: { () -> Void in
//                Logger.log("Progress \(progress.fractionCompleted)")
//            })
//        }
//
//        var uploadCompletionHandlerBlock: AWSS3TransferUtilityUploadCompletionHandlerBlock?
//
//        uploadCompletionHandlerBlock = { (task, error) in
//            DispatchQueue.main.sync(execute: { () -> Void in
//                if error == nil {
//                    Logger.log("uploadCompletionHandler: Upload Success!")
//                    let key = self.sendInfo()
//
//                    let parameters = self.videoParameters(uniqId: key)
//
//                    Alamofire.request(self.zapierUrl, parameters: parameters).responseData { response in
//                        switch response.result {
//                        case .success:
//                            Logger.log("Successfully Submitted to Zapier!")
//                        case .failure(let error):
//                            Logger.log(level: Level.error, "Failure submitting to Zapier!")
//                            Logger.forceLog(CustomError.videoUploadError(error.localizedDescription))
//                        }
//                    }
//                } else {
//                    Logger.forceLog(CustomError.videoUploadError(error!.localizedDescription))
//                }
//            })
//        }
//
//        let uploadExpression = AWSS3TransferUtilityUploadExpression()
//
//        uploadExpression.setValue("public-read", forRequestHeader: "x-amz-acl")
//
//        transferUtility.uploadFile(video.url, bucket: video.bucketName, key: video.name, contentType: "application/octet-stream", expression: uploadExpression, completionHandler: uploadCompletionHandlerBlock).continueWith(block: { (task) -> AnyObject! in
//            if let error = task.error {
//                Logger.log(level: Level.error, "Failure uploading video!")
//                Logger.forceLog(CustomError.videoUploadError(error.localizedDescription))
//            } else {
//                DispatchQueue.main.async(execute: {
//                    Logger.log("Something to do immediately afterwards. Not necessarily done")
//                })
//            }
//            return nil
//        })

        let key = self.sendInfo()

        let storageRef = storage.reference()
        let photoPathRef = storageRef.child("caseVideos/\(key)/\(video.name)")

        do {
            let data = try Data.init(contentsOf: video.url)
            let _ = photoPathRef.putData(data, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    Logger.log("Error saving photo reference \(error.localizedDescription)")
                    return
                }
            })
//                let _ = photoPathRef.putData(data, metadata: nil) { (metadata, error) in
//                    if let error = error {
//                        Logger.log("Error saving photo reference \(error.localizedDescription)")
//                        return
//                    }
//                }

        } catch {
            print("Error")
        }

    }

    func submit() {
        if let video = self.video {
            self.bgUploadToS3(video: video)
        }
    }

    func videoParameters(uniqId: String) -> Parameters {
        let defaults = UserDefaults.standard

        if let v = self.video {
            return [ "email" :  defaults.string(forKey: "email")!,
                     "name" : defaults.string(forKey: "name")!,
                     "video" : v.videoLink,
                     "ID": uniqId]
        } else {
            return [:]
        }
    }

    func sendInfo() -> String {
        currentCase.submitCase(to: ref)
        return currentCase.key ?? "No key returned"
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.submit()
    }
}
