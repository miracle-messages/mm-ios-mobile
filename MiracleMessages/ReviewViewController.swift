//
//  ReviewViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class ReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientDobLabel: UILabel!
    @IBOutlet weak var clientLocationLabel: UILabel!
    @IBOutlet weak var clientHometownLabel: UILabel!
    @IBOutlet weak var yearsAwayLabel: UILabel!
    @IBOutlet weak var clientContactLabel: UILabel!
    @IBOutlet weak var clientOtherInfoLabel: UILabel!
    @IBOutlet weak var clientPartnerOrgLabel: UILabel!

    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientRelationshipLabel: UILabel!
    @IBOutlet weak var recipientAgeLabel: UILabel!
    @IBOutlet weak var recipientLocationLabel: UILabel!
    @IBOutlet weak var recipientYearsDisconnectedLabel: UILabel!

    @IBOutlet weak var recipientOtherInfoLabel: UILabel!

    var clientInfo: BackgroundInfo?
    
    let picker = UIImagePickerController()
    let storage = FIRStorage.storage()
    var ref: FIRDatabaseReference!
    var caseID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clientInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
        displayInfo()
    }

    func displayInfo() -> Void {
        guard let backgroundInfo = self.clientInfo else { return }
        if let clientName = backgroundInfo.client_name {
            clientNameLabel.text = "From: \(clientName)"
        }
        if let clientDob = backgroundInfo.client_dob {
            clientDobLabel.text = "Date of birth: \(clientDob)"
        }
        if let clientCurrentCity = backgroundInfo.client_current_city {
            clientLocationLabel.text = "Location: \(clientCurrentCity)"
        }
        if let clientHometown = backgroundInfo.client_hometown {
            clientHometownLabel.text = "Hometown: \(clientHometown)"
        }
        if let clientYearsAway = backgroundInfo.client_years_homeless {
            yearsAwayLabel.text = "Years away from home: \(clientYearsAway)"
        }
        if let clientContact = backgroundInfo.client_contact_info {
            clientContactLabel.text = clientContact
        }
        if let clientOtherInfo = backgroundInfo.client_other_info {
            clientOtherInfoLabel.text = "Other info: \(clientOtherInfo)"
        }
        if let clientPartnerOrg = backgroundInfo.client_partner_org {
            clientPartnerOrgLabel.text = "Partner org: \(clientPartnerOrg)"
        }
        if let recipientName = backgroundInfo.recipient_name {
            recipientNameLabel.text = "To: \(recipientName)"
        }
        if let recipientRelationship = backgroundInfo.recipient_relationship {
            recipientRelationshipLabel.text = "Relationship: \(recipientRelationship)"
        }
        if let recipientAge = backgroundInfo.recipient_dob {
            recipientAgeLabel.text = "DOB: \(recipientAge)"
        }
        if let recipientLocation = backgroundInfo.recipient_last_location {
            recipientLocationLabel.text = "Location: \(recipientLocation)"
        }
        if let recipientYearsDisconnected = backgroundInfo.recipient_years_since_last_seen {
            recipientYearsDisconnectedLabel.text = "Years disconnected: \(recipientYearsDisconnected)"
        }
        if let recipientOtherInfo = backgroundInfo.recipient_other_info {
            recipientOtherInfoLabel.text = recipientOtherInfo
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "photoReferenceViewController" {
            let backgroundController = segue.destination as? BackgroundInfoViewController
            backgroundController?.backgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
            backgroundController?.mode = .update
            backgroundController?.delegate = self
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "cameraViewController" || identifier == "photoReferenceViewController"  {
            if !UIImagePickerController.isCameraDeviceAvailable(.rear) {
                let alert = UIAlertController(title: "Cannot access camera.", message: "You will need a rear-view camera to record an interview", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func didTapRecordBtn(_ sender: Any) {
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
}

extension ReviewViewController {
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
        picker.dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "cameraViewController", sender: self)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ReviewViewController: BackgroundInfoDelegate {
    func didFinishUpdating() {
        self.clientInfo?.save()
        displayInfo()
    }
}



extension ReviewViewController: CameraViewControllerDelegate {
    func didFinishRecording(sender: CameraViewController) -> Void {
        guard let navController = self.navigationController else {return}
        for aviewcontroller in navController.viewControllers
        {
            if aviewcontroller is LoginSummaryViewController
            {
                navController.popToViewController(aviewcontroller, animated: true)
            }
        }
    }
}
