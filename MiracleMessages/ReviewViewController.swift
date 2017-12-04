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
import SnapKit
import NVActivityIndicatorView

class ReviewViewController: UIViewController, CaseDelegate, NVActivityIndicatorViewable {
    var currentCase: Case = Case.current
    var lovedOnes: [LovedOne] = []
    let picker = UIImagePickerController()
    let storage = Storage.storage()
    var ref: DatabaseReference!
    var caseID: String!
    var croppedImage: UIImage?
    var isEditPhoto: Bool = false

    @IBOutlet weak var tblReview: UITableView!
    
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
        
        if(isEditPhoto == true){
            self.openCamera()
        }
        currentCase = Case.current
        lovedOnes = Array(currentCase.lovedOnes)
        self.tblReview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                showCameraError()
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
    func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
    
    func openCamera(){
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            ref = Database.database().reference()
            caseID = ref.child("clients").childByAutoId().key
            caseID = self.currentCase.key
            UserDefaults.standard.set(caseID, forKey: Keys.caseID)
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            overlayView.backgroundColor = UIColor.clear
            overlayView.isUserInteractionEnabled = false
            let overlayLabel = UILabel(frame: CGRect.zero)
            overlayLabel.numberOfLines = 0
            overlayLabel.font = UIFont.init(name: "Arial", size: 20)
            overlayLabel.textColor = UIColor.white
            overlayLabel.textAlignment = .center
            overlayLabel.text = "Take a photo of the individual for reference. Find a well-lit area and frame the face in the middle of the screen."
            overlayView.addSubview(overlayLabel)
            overlayLabel.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview().offset(-135)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
            })
            picker.cameraOverlayView = overlayView
            
            present(picker,animated: false,completion: nil)
        } else {
            showCameraError()
        }
    }
    
    @IBAction func didTapRecordBtn(_ sender: Any) {
        self.openCamera()
    }
}

private extension ReviewViewController {
    func showCameraError() {
        let alert = UIAlertController(title: "Cannot access camera.", message: "You will need a rear-view camera to record an interview", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension ReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
        //Send image to firebase
        self.ShowActivityIndicator()
        let storageRef = storage.reference()
        let photoPathRef = storageRef.child("casePictures/\(currentCase.key!)/photoReference.jpg")
        let referenceImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if let croppedImage = cropImageToSquare(image: referenceImage){
            //currentCase.casePhoto = referenceImage
            let newMeta = StorageMetadata()
            newMeta.contentType = "image/jpeg"
            if let data = UIImageJPEGRepresentation(croppedImage, 90.0) {
                let _ = photoPathRef.putData(data, metadata: newMeta) { (metadata, error) in
                    if let error = error {
                        self.RemoveActivityIndicator()
                        Logger.log("Error saving photo reference \(error.localizedDescription)")
                        return
                    }else{
                        self.currentCase.photoURL = metadata?.downloadURL()
                        
                        guard let key = self.currentCase.key else {return}
                        let publicPayload: [String: Any] = [
                            "photo": metadata?.downloadURL()?.absoluteString,
                            ]
                        
                        let caseReference: DatabaseReference
                        caseReference = self.ref.child("/cases/\(key)")
                        
                        //  Write case data
                        caseReference.updateChildValues(publicPayload) { error, _ in
                            self.RemoveActivityIndicator()
                            //  If unsuccessful, print and return
                            guard error == nil else {
                                self.showAlertView()
                                print(error!.localizedDescription)
                                Logger.log(error!.localizedDescription)
                                Logger.log("\(publicPayload)")
                                return
                            }
                            
                            picker.dismiss(animated: true, completion: {
                                if(self.isEditPhoto == false){
                                    self.performSegue(withIdentifier: "cameraController", sender: self)
                                } else{
                                    let confirmController = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
                                    self.navigationController?.pushViewController(confirmController, animated: true)
                                }
                            })
                        }
                        Logger.log("Saved the photo for the case \(self.currentCase.key!) \(self.currentCase.photoURL!)")
                    }
                }
            }
        }
        else{
            Logger.log("Unable to save the photo for this case: \(currentCase.key!)")
            return
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
            print(currentCase)

            return cell
        case 1:
            guard currentCase.lovedOnes.count > 0 else {
                return tableView.dequeueReusableCell(withIdentifier: "noneCell", for: indexPath)
            }

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "toCell", for: indexPath) as? ReviewTableViewCell else { break }

            cell.reviewable = lovedOnes[indexPath.row]
            print(lovedOnes[indexPath.row])

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
