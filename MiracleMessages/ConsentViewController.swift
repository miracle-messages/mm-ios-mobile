//
//  ConsentViewController.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 6/25/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import AWSS3
import FirebaseStorage

class ConsentViewController: UIViewController {
    @IBOutlet weak var signatureView: YPDrawSignatureView!

    let storage = Storage.storage()

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

            let storageRef = storage.reference()
            let signaturePathRef = storageRef.child("caseSignatures/test/signature.jpg")

            do {
                let data = try Data.init(contentsOf: imageUrl)
                let _ = signaturePathRef.putData(data, metadata: nil) { (metadata, error) in
                    if let error = error {
                        Logger.log("Error saving signature \(error.localizedDescription)")
                        return
                    } else {
                        print("Saved signature")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewController(withIdentifier: "BackgroundInfo1ViewController")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } catch {
                Logger.log("There was an issue processing image data for signature")
            }
        }
    }
 

}
