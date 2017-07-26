//
//  PhotoReferenceViewController.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 7/3/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PhotoReferenceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    let storage = FIRStorage.storage()
    var ref: FIRDatabaseReference!
    var caseID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        caseID = ref.child("clients").childByAutoId().key
        UserDefaults.standard.set(caseID, forKey: Keys.caseID)
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: false,completion: nil)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

extension PhotoReferenceViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Send image to firebase
        let storageRef = storage.reference()
        let photoPathRef = storageRef.child("casePictures/\(caseID!)/photoReference.jpg")
        let referenceImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let data = UIImageJPEGRepresentation(referenceImage, 90.0) {
            let _ = photoPathRef.put(data, metadata: nil) { (metadata, error) in
                if let error = error {
                    Logger.log("Error saving photo reference \(error.localizedDescription)")
                    return
                }
            }
        }
        performSegue(withIdentifier: "cameraViewController", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
