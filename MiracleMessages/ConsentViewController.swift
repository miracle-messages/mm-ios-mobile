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
import Firebase

class ConsentViewController: UIViewController {
    @IBOutlet weak var signatureView: YPDrawSignatureView!

    var currentCase = Case.current
    let storage = Storage.storage()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        signatureView.layer.borderWidth = 1
        signatureView.layer.borderColor = UIColor.lightGray.cgColor
        ref = Database.database().reference()
        
    }
    
    @IBAction func didTapClearBtn(_ sender: Any) {
        signatureView.clear()
    }
    
    @IBAction func didTapConsentBtn(_ sender: Any) {
        if let imageUrl = signatureView.saveAsJPEG() {
            currentCase.generateKey(withRef: ref)
            let storageRef = storage.reference()
            guard let key = currentCase.key else {return}
            let signaturePathRef = storageRef.child("caseSignatures/\(key)/signature.jpg")
            do {
                let data = try Data.init(contentsOf: imageUrl)
                let _ = signaturePathRef.putData(data, metadata: nil) { (metadata, error) in
                    if let error = error {
                        Logger.log("Error saving signature \(error.localizedDescription)")
                        return
                    } else {
                        print("Saved signature")
                        self.currentCase.signatureURL = metadata?.downloadURL()
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
