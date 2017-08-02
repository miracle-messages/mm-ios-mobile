//
//  ConsentViewController.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 6/25/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import AWSS3

class ConsentViewController: UIViewController {
    @IBOutlet weak var signatureView: YPDrawSignatureView!

    override func viewDidLoad() {
        super.viewDidLoad()
        signatureView.layer.borderWidth = 1
        signatureView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func didTapClearBtn(_ sender: Any) {
        signatureView.clear()
    }
    
    @IBAction func didTapConsentBtn(_ sender: Any) {
        if let imageUrl = signatureView.saveAsJPEG() {
            var uploadCompletionBlock: AWSS3TransferUtilityUploadCompletionHandlerBlock
            
            uploadCompletionBlock = { (task, error) in
                DispatchQueue.main.sync(execute: { () -> Void in
                    if error == nil {
                        print("Successfully updated image")
                        print("task\(task)")
                        //Could save the task.key in NSUserDefaults to be saved in Firebase
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "BackgroundInfo1ViewController")
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        print("Error here: \(error.debugDescription)")
                    }
                })
            }
            let signature = Signature(url: imageUrl, name: "signatureImg", completionBlock: uploadCompletionBlock, bucketName: "mm-signatures", contentType: "image/jpeg")
            let _ = signature.upload()
        }
    }
 

}
