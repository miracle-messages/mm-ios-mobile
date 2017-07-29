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

class ConfirmViewController: UIViewController {

    var video: Video?
    var ref: FIRDatabaseReference!
    let currentCase: Case = Case.current
    let zapierUrl = "https://hooks.zapier.com/hooks/catch/1838547/hshdv5/"

    //"https://hooks.zapier.com/hooks/catch/1838547/tsx0t0/"
    //https://hooks.zapier.com/hooks/catch/1838547/hshdv5/

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        self.navigationController?.navigationItem.backBarButtonItem?.title = "test"

        // Do any additional setup after loading the view.
    }

    func bgUploadToS3(video: Video) -> Void {
        let transferUtility = AWSS3TransferUtility.default()
        let transferExpression = AWSS3TransferUtilityUploadExpression()

        transferExpression.progressBlock = { (task, progress) in
            DispatchQueue.main.sync(execute: { () -> Void in
                print("Progress \(progress.fractionCompleted)")
            })
        }

        var uploadCompletionHandlerBlock: AWSS3TransferUtilityUploadCompletionHandlerBlock?

        uploadCompletionHandlerBlock = { (task, error) in
            DispatchQueue.main.sync(execute: { () -> Void in
                if error == nil {
                    let key = self.sendInfo()

                    let parameters = self.videoParameters(uniqId: key)

                    Alamofire.request(self.zapierUrl, parameters: parameters).responseData { response in
                        switch response.result {
                        case .success:
                            print("Submitted")
                        case .failure(let error):
                            print(error)
                        }
                    }
                } else {
                    print("Error here: \(error.debugDescription)")
                }
            })
        }

        let uploadExpression = AWSS3TransferUtilityUploadExpression()

        uploadExpression.setValue("public-read", forRequestHeader: "x-amz-acl")

        transferUtility.uploadFile(video.url, bucket: video.bucketName, key: video.name, contentType: "application/octet-stream", expression: uploadExpression, completionHander: uploadCompletionHandlerBlock).continue( { (task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(String(describing: task.error))")
            } else {
                DispatchQueue.main.async(execute: {
                    print("something to do immediately afterwards. Not necessarily done")
                })
            }
            return nil
        })
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
