//
//  DraftPhotoVideoViewController.swift
//  MiracleMessages
//
//  Created by Ved on 05/12/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import NVActivityIndicatorView
import MobileCoreServices
import AVFoundation

class DraftPhotoVideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    
    let storage = Storage.storage()
    let currentCase: Case = Case.current
    var ref: DatabaseReference!
    let picker = UIImagePickerController()
    var videoPickerController = UIImagePickerController()
    var caseID: String = ""
    var videoURL: URL?
    var isPhoto: Bool = true
    
    let bucketName: String = "mm-interview-vids"
    let awsHost: String = "https://s3-us-west-2.amazonaws.com"
    let questionsArray: [String] = [
        "Hold your phone horizontally, hit record, and reconfirm permission on camera. 'Do we have your permission to record and share this video?' Once they say 'Yes', invite them to look at the camera, and speak to their loved one as if they were there."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CASE ID --->\(self.caseID)")
        
        self.btnPhoto.layer.cornerRadius = 4
        self.btnPhoto.layer.masksToBounds = true
        
        self.btnVideo.layer.cornerRadius = 4
        self.btnVideo.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnHomeclicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUploadVideoClicked(_ sender: Any) {
        isPhoto = false
        self.pickVideoFromGallery()
    }
    
    @IBAction func btnCapturePhotoClicked(_ sender: Any) {
        isPhoto = true
        self.openCamera()
    }
    
    func pickVideoFromGallery(){
        videoPickerController.sourceType = .savedPhotosAlbum
        videoPickerController.delegate = self
        videoPickerController.mediaTypes = [(kUTTypeMovie as NSString) as String]
        self.present(videoPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if(self.isPhoto == true){
            //Send image to firebase
            self.ShowActivityIndicator()
            let storageRef = storage.reference()
            let photoPathRef = storageRef.child("casePictures/\(self.caseID)/photoReference.jpg")
            let referenceImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.btnPhoto.setImage(referenceImage, for: .normal)
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
                            
                            let publicPayload: [String: Any] = [
                                "photo": metadata?.downloadURL()?.absoluteString,
                                ]
                            
                            let caseReference: DatabaseReference
                            caseReference = self.ref.child("/cases/\(self.caseID)")
                            
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
                                    
                                })
                            }
                            Logger.log("Saved the photo for the case \(self.caseID)")
                        }
                    }
                }
            }
            else{
                Logger.log("Unable to save the photo for this case: \(self.caseID)")
                return
            }
        } else{
        
        videoURL = info[UIImagePickerControllerMediaURL] as! NSURL as URL
        print(videoURL!)
            
            self.btnVideo.setImage(self.videoSnapshot(filePathLocal: videoURL! as NSURL), for: .normal)
        
        // get the asset
        let asset = AVURLAsset(url: videoURL!)
        // get the time in seconds
        let seconds = asset.duration.seconds
        NSLog("duration: %.2f", seconds);
        
        self.dismiss(animated: true, completion: nil)
        
        if(seconds >= 180){
            // create the alert
            let alert = UIAlertController(title: "Miracle Messages", message: "Sorry! you can't upload more than 3 minutes video.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            }))
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: { action in
                self.pickVideoFromGallery()
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else{
            self.presentConfirmation(outputFileURL: videoURL)
        }
        }
    }
    
    func videoSnapshot(filePathLocal: NSURL) -> UIImage? {
        
        // let vidURL = NSURL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: filePathLocal as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    func presentConfirmation(outputFileURL: URL!) -> Void {
        let video = Video(contentType: "application/octet-stream", completionBlock: nil, awsHost: self.awsHost, bucketName: self.bucketName, name: self.generateVideoFileName(), url: outputFileURL)
        self.bgUploadToS3(video: video)
    }
    
    func generateVideoFileName() -> String {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")?.replacingOccurrences(of: " ", with: "-").lowercased()
        let date = Date()
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MM-dd-yyyy-HHmmss"
        let stringDate = dayTimePeriodFormatter.string(from: date)
        return "\(name!)-\(stringDate).mov"
    }
    
    func bgUploadToS3(video: Video) -> Void {
        
        //UNCOMMENT this code to play with Firebase storage
        //let key = self.sendInfo()
        self.ShowActivityIndicator()
        let key = self.caseID
        let storageRef = storage.reference()
        let photoPathRef = storageRef.child("caseVideos/\(key)/\(video.name)")
        let newMeta = StorageMetadata()
        newMeta.contentType = "video/quicktime"
        Logger.log("Firebase video ref \(photoPathRef)")
        do {
            let data = try Data.init(contentsOf: video.url)
            let _ = photoPathRef.putData(data, metadata: newMeta, completion: { (metadata, error) in
                if let error = error {
                    self.RemoveActivityIndicator()
                    Logger.log("Error saving photo reference \(error.localizedDescription)")
                    return
                }
               
                let caseReference: DatabaseReference
                caseReference = self.ref.child("/cases/\(self.caseID)")
                
                let url = metadata?.downloadURL()?.absoluteString
                
                let publicPayload: [String: Any] = [
                    "caseStatus": self.currentCase.caseStatus.rawValue,
                    "messageStatus": self.currentCase.messageStatus.rawValue,
                    "nextStep": self.currentCase.nextStep.rawValue,
                    "source": self.currentCase.source.dictionary,
                    "detectives": self.currentCase.detectives.count > 0,
                    "submitted": Int(Date().timeIntervalSince1970),
                    "privVideo": url!,
                    "publishStatus": "published",
                    ]
                
                print("Public Payload\(publicPayload)")
                
                // Write case data
                caseReference.updateChildValues(publicPayload) { error, _ in
                    self.RemoveActivityIndicator()
                    // If unsuccessful, print and return
                    guard error == nil else {
                        self.showAlertView()
                        print(error!.localizedDescription)
                        Logger.log(error!.localizedDescription)
                        Logger.log("\(publicPayload)")
                        return
                    }
                }
            })
            
        } catch {
            print("Error")
            self.RemoveActivityIndicator()
        }
        
    }

    
    func openCamera(){
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            ref = Database.database().reference()
            self.caseID = ref.child("clients").childByAutoId().key
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
    
    func showCameraError() {
        let alert = UIAlertController(title: "Cannot access camera.", message: "You will need a rear-view camera to record an interview", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
