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
    let backgroundInfo: BackgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
    let zapierUrl = "https://hooks.zapier.com/hooks/catch/1838547/hshdv5/"

    //"https://hooks.zapier.com/hooks/catch/1838547/tsx0t0/"
    //https://hooks.zapier.com/hooks/catch/1838547/hshdv5/

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        self.navigationController?.navigationItem.backBarButtonItem?.title = "test"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                print("Error: \(task.error)")
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
        //Create new user ID
        let defaults = UserDefaults.standard

        let key = ref.child("clients").childByAutoId().key
        
        //Create new client info payload
        let payload = [
            "volunteer_name" : defaults.string(forKey: "name")!,
            "volunteer_email" : defaults.string(forKey: "email")!,
            "volunteer_phone" : defaults.string(forKey: "phone")!,
            "volunteer_location" : defaults.string(forKey: "location")!,
            "client_name" : self.backgroundInfo.client_name ?? "missing name",
            "client_dob" : self.backgroundInfo.client_dob!,
            "client_current_city" : self.backgroundInfo.client_current_city!,
            "client_hometown" : self.backgroundInfo.client_hometown!,
            "client_contact_info" : self.backgroundInfo.client_contact_info!,
            "client_other_info" : self.backgroundInfo.client_other_info!,
            "client_partner_org" : self.backgroundInfo.client_partner_org!,
            "client_years_homeless" : self.backgroundInfo.client_years_homeless!,
            "recipient_name" : self.backgroundInfo.recipient_name!,
            "recipient_dob" : self.backgroundInfo.recipient_dob!,
            "recipient_relationship" : self.backgroundInfo.recipient_relationship!,
            "recipient_last_location" : self.backgroundInfo.recipient_last_location!,
            "recipient_last_seen" : self.backgroundInfo.recipient_years_since_last_seen!,
            "recipient_other_info" : self.backgroundInfo.recipient_other_info!,
            "volunteer_uploaded_url" : self.video?.videoLink ?? "none",
            "created_at" : floor(NSDate().timeIntervalSince1970)
            ] as [String : Any]

        //Send payload to server
        let childUpdates = ["/clients/\(key)": payload]
        ref.updateChildValues(childUpdates)
        return key
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.submit()
    }


}
