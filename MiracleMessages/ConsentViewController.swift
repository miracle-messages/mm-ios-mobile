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
import NVActivityIndicatorView

class ConsentViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var signatureView: YPDrawSignatureView!

    var currentCase: Case!
    let storage = Storage.storage()
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        signatureView.layer.borderWidth = 1
        signatureView.layer.borderColor = UIColor.lightGray.cgColor
        ref = Database.database().reference()
        
        currentCase = Case.startNewCase()
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
    
    func saveSignatureAndStatusToFirebase(signatureURL : URL){
        self.ShowActivityIndicator()
        guard let key = currentCase.key else {return}
        let privatePayload: [String: Any] = [
            "signatureUrl": signatureURL.absoluteString ,
            ]
        
        let privateCaseReference = ref.child("/casesPrivate/\(key)")
        
        //  If successful, write private case data
        privateCaseReference.setValue(privatePayload) { error, _ in
            self.RemoveActivityIndicator()
            //  If private write unsuccessful, remove case data and return
            guard error == nil else {
                self.showAlertView()
                print(error!.localizedDescription)
                return
            }
            
            //Push {publishStatus: 'draft'} to the database
            let caseStatusReference: DatabaseReference
            caseStatusReference = self.ref.child("/cases/\(key)")
            
            var statusPayload: [String: Any] = [
                "publishStatus": "draft",
                ]
            
            guard let currentUser = Auth.auth().currentUser else { return }
            
            statusPayload["createdBy"] = ["uid": currentUser.uid]
            
            print("Payload\(statusPayload)")
            
            //  Write case data
            caseStatusReference.setValue(statusPayload) { error, _ in
                self.RemoveActivityIndicator()
                //  If unsuccessful, print and return
                guard error == nil else {
                    self.showAlertView()
                    print(error!.localizedDescription)
                    Logger.log(error!.localizedDescription)
                    Logger.log("\(statusPayload)")
                    return
                }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "BackgroundInfo1ViewController")
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func didTapClearBtn(_ sender: Any) {
        signatureView.clear()
    }

    @IBAction func didTapConsentBtn(_ sender: Any) {
         self.ShowActivityIndicator()
        if let imageUrl = signatureView.saveAsJPEG() {
            currentCase.generateKey(withRef: ref)
            let storageRef = storage.reference()
            guard let key = currentCase.key else {return}
           
            let signaturePathRef = storageRef.child("caseSignatures/\(key)/signature.jpg")
            let newMeta = StorageMetadata()
            newMeta.contentType = "image/jpeg"
            do {
                let data = try Data.init(contentsOf: imageUrl)
                let _ = signaturePathRef.putData(data, metadata: newMeta) { (metadata, error) in
                    if let error = error {
                        self.showAlertView()
                        self.RemoveActivityIndicator()
                        Logger.log("Error saving signature \(error.localizedDescription)")
                        return
                    } else {
                        print("Saved signature")
                        self.currentCase.signatureURL = metadata?.downloadURL()
                        self.saveSignatureAndStatusToFirebase(signatureURL: (metadata?.downloadURL())!)
                    }
                }
            } catch {
                self.RemoveActivityIndicator()
                Logger.log("There was an issue processing image data for signature")
            }
        } else{
            self.RemoveActivityIndicator()
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

}
