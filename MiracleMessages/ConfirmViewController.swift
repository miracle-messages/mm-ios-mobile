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
import NVActivityIndicatorView
struct Keys {
    static let caseID = "caseID"
}

class ConfirmViewController: UIViewController, NVActivityIndicatorViewable {

    var video: Video?
    var ref: DatabaseReference!
    let currentCase: Case = Case.current
    let storage = Storage.storage()

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.navigationItem.backBarButtonItem?.title = "test"
    }
    
    //Show activity indicator while saving data
    func ShowActivityIndicator(){
        
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
    
    //Remove activity indicator
    func RemoveActivityIndicator(){
        stopAnimating()
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
//                    let _ = self.sendInfo()
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

        //UNCOMMENT this code to play with Firebase storage
        //let key = self.sendInfo()
        self.ShowActivityIndicator()
        let key = self.currentCase.key
        let storageRef = storage.reference()
        let photoPathRef = storageRef.child("caseVideos/\(key!)/\(video.name)")
        let newMeta = StorageMetadata()
        newMeta.contentType = "video/quicktime"
        Logger.log("Firebase video ref \(photoPathRef)")
        do {
            let data = try Data.init(contentsOf: video.url)
            let _ = photoPathRef.putData(data, metadata: newMeta, completion: { (metadata, error) in
                if let error = error {
                    self.RemoveActivityIndicator()
                    Logger.log("Error saving photo reference \(error.localizedDescription)")
                    return
                }
                self.currentCase.privateVideoURL = metadata?.downloadURL()
                guard let caseKey = self.currentCase.key else {return}
                let caseReference: DatabaseReference
                caseReference = self.ref.child("/cases/\(caseKey)")
                
                let url = metadata?.downloadURL()?.absoluteString
                
                let publicPayload: [String: Any] = [
                    "caseStatus": self.currentCase.caseStatus.rawValue,
                    "messageStatus": self.currentCase.messageStatus.rawValue,
                    "nextStep": self.currentCase.nextStep.rawValue,
                    "source": self.currentCase.source.dictionary,
                    "detectives": self.currentCase.detectives.count > 0,
                    "submitted": Int(Date().timeIntervalSince1970),
                    "privVideo": url!,
                    "publishStatus": "published",
                    ]
                
                print("Public Payload\(publicPayload)")
                
                // Write case data
                caseReference.updateChildValues(publicPayload) { error, _ in
                    self.RemoveActivityIndicator()
                    // If unsuccessful, print and return
                    guard error == nil else {
                        self.showAlertView()
                        print(error!.localizedDescription)
                        Logger.log(error!.localizedDescription)
                        Logger.log("\(publicPayload)")
                        return
                    }
                    
                }
            })

        } catch {
            print("Error")
        }

    }
    
    func showAlertView(){
        // create the alert
        let alert = UIAlertController(title: "Miracle Messages", message: "Something went wrong. please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
