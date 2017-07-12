//
//  PhotoReferenceViewController.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 7/3/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import Firebase

class PhotoReferenceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    let storage = Storage.storage()
    // Create a storage reference from our storage service
    let storageRef = storage.reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker,animated: false,completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension PhotoReferenceViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Send image to firebase
        let referenceImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
