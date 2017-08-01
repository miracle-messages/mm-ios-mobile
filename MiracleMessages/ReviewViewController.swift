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

class ReviewViewController: UIViewController, CaseDelegate {
    var currentCase: Case = Case.current
    var lovedOnes: [LovedOne] = []
    
    let picker = UIImagePickerController()
    let storage = Storage.storage()
    var ref: DatabaseReference!
    var caseID: String!

    let dateFormatter: DateFormatter = {
        let this = DateFormatter()
        this.dateStyle = .long
        this.timeStyle = .none
        return this
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentCase = Case.current
        lovedOnes = Array(currentCase.lovedOnes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cameraController = segue.destination as? CameraViewController {
            cameraController.delegate = self
        } else if let destination = segue.destination as? BackgroundInfo1ViewController {
            destination.mode = .update
        } else if let destination = segue.destination as? BackgroundInfo2ViewController, let sender = sender as? ReviewTableViewCell, let lovedOne = sender.reviewable as? LovedOne {
            destination.mode = .update
            destination.currentLovedOne = lovedOne
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "camerController"  {
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
        ref = Database.database().reference()
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

extension ReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Send image to firebase
        let storageRef = storage.reference()
        let photoPathRef = storageRef.child("casePictures/\(caseID!)/photoReference.jpg")
        let referenceImage = info[UIImagePickerControllerOriginalImage] as! UIImage

        if let data = UIImageJPEGRepresentation(referenceImage, 90.0) {
            let _ = photoPathRef.putData(data, metadata: nil) { (metadata, error) in
                if let error = error {
                    Logger.log("Error saving photo reference \(error.localizedDescription)")
                    return
                }
            }
        }
        picker.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "cameraController", sender: self)
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func didFinishUpdating() {
        //  TODO: Check if these are really needed

        //self.theCase?.save()
        //displayInfo()
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

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2    //  One for Sender, one for Recipients
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return currentCase.lovedOnes.isEmpty ? 1 : currentCase.lovedOnes.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fromCell", for: indexPath) as? ReviewTableViewCell else { break }

            cell.reviewable = currentCase

            return cell
        case 1:
            guard currentCase.lovedOnes.count > 0 else {
                return tableView.dequeueReusableCell(withIdentifier: "noneCell", for: indexPath)
            }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "toCell", for: indexPath) as? ReviewTableViewCell else { break }

            cell.reviewable = lovedOnes[indexPath.row]

            return cell
        default: break
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
