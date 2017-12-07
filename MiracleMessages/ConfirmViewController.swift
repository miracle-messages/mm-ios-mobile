//
//  ConfirmViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import AWSS3
import FirebaseDatabase
import Alamofire
import FirebaseStorage
import NVActivityIndicatorView
import AVFoundation

struct Keys {
    static let caseID = "caseID"
}

class ConfirmViewController: UIViewController, NVActivityIndicatorViewable {

    var video: Video?
    var ref: DatabaseReference!
    let currentCase: Case = Case.current
    var lovedOnes: [LovedOne] = []
    let storage = Storage.storage()
    var arrConfirmData :  NSMutableArray = []
    @IBOutlet weak var tblConfirm: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        lovedOnes = Array(currentCase.lovedOnes)
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.navigationController?.navigationItem.backBarButtonItem?.title = "test"
        self.setConfirmViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblConfirm.reloadData()
    }
    
    func setConfirmViewData(){
        let dictPhoto : NSDictionary!
        let dictVideo : NSDictionary!
        
        if self.currentCase.photoURL != nil{
            dictPhoto = ["lblName":"Case Photo","imgPhoto":self.currentCase.photoURL!] as NSDictionary
        } else {
            dictPhoto = ["lblName":"No Case Photo","imgPhoto":nil] as NSDictionary
        }
        
        if self.currentCase.localVideoURL != nil{
            dictVideo = ["lblName":"Recording","imgPhoto":self.currentCase.localVideoURL!] as NSDictionary
        } else {
            dictVideo = ["lblName":"No Recording","imgPhoto":nil] as NSDictionary
        }
        
        self.arrConfirmData = [dictPhoto, dictVideo] as NSMutableArray
        self.tblConfirm.reloadData()
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
    
    //Show activity indicator while saving data
    func ShowActivityIndicator(){
        
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
    
    //Remove activity indicator
    func RemoveActivityIndicator(){
        stopAnimating()
    }
    
    func saveDataToFirebase(privateVideoURL: URL?){
        self.ShowActivityIndicator()
        guard let caseKey = self.currentCase.key else {return}
        let caseReference: DatabaseReference
        caseReference = self.ref.child("/cases/\(caseKey)")
        
        var publicPayload: [String: Any] = [
            "caseStatus": self.currentCase.caseStatus.rawValue,
            "messageStatus": self.currentCase.messageStatus.rawValue,
            "nextStep": self.currentCase.nextStep.rawValue,
            "source": self.currentCase.source.dictionary,
            "detectives": self.currentCase.detectives.count > 0,
            "submitted": Int(Date().timeIntervalSince1970),
            "publishStatus": "published",
            ]
        
        if let url = privateVideoURL?.absoluteString {
            publicPayload["privVideo"] = url
        }
        
        print("Public Payload\(publicPayload)")
        
        // Write case data
        caseReference.updateChildValues(publicPayload) { error, _ in
            self.RemoveActivityIndicator()
            // If unsuccessful, print and return
            guard error == nil else {
                self.showAlertView()
                print(error!.localizedDescription)
                Logger.log("\(publicPayload)")
                return
            }
            
            let nextController = self.storyboard!.instantiateViewController(withIdentifier: "NextViewController") as! NextViewController
            self.navigationController?.pushViewController(nextController, animated: true)
            
        }
    }

    func bgUploadToS3(video: Video) -> Void {

        //UNCOMMENT this code to play with Firebase storage
        //let key = self.sendInfo()
        self.ShowActivityIndicator()
        let key = self.currentCase.key
        let storageRef = storage.reference()
        let photoPathRef = storageRef.child("caseVideos/\(key!)/\(video.name)")
        let newMeta = StorageMetadata()
        newMeta.contentType = "video/quicktime"
        Logger.log("Firebase video ref \(photoPathRef)")
        do {
            let data = try Data.init(contentsOf: video.url)
            let _ = photoPathRef.putData(data, metadata: newMeta, completion: { (metadata, error) in
                self.RemoveActivityIndicator()
                if let error = error {
                    Logger.log("Error saving photo reference \(error.localizedDescription)")
                    return
                }
                self.currentCase.privateVideoURL = metadata?.downloadURL()
                self.saveDataToFirebase(privateVideoURL: metadata?.downloadURL())
            })

        } catch {
            print("Error")
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
    
    @IBAction func btnSubmitClicked(sender: UIButton) {
        if let video = self.video {
            self.bgUploadToS3(video: video)
        } else{
            self.saveDataToFirebase(privateVideoURL: nil)
        }
    }
    

    func submit() {
        if let video = self.video {
            self.bgUploadToS3(video: video)
        }
    }

    func videoParameters(uniqId: String) -> Parameters {
        let defaults = UserDefaults.standard

        if let v = self.video {
            return [ "email" :  defaults.string(forKey: "email")!,
                     "name" : defaults.string(forKey: "name")!,
                     "video" : v.videoLink,
                     "ID": uniqId]
        } else {
            return [:]
        }
    }

    func sendInfo() -> String {
        currentCase.submitCase(to: ref)
        return currentCase.key ?? "No key returned"
    }

    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        self.submit()
//    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}

extension ConfirmViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3  //  One for Sender, one for Recipients
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return currentCase.lovedOnes.isEmpty ? 1 : currentCase.lovedOnes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            var cell: ConfirmTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "ConfirmTableViewCell") as? ConfirmTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "ConfirmTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmTableViewCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmTableViewCell") as? ConfirmTableViewCell
            }
        
            let dict : NSDictionary = self.arrConfirmData[indexPath.row] as! NSDictionary
            cell.lblName.text = dict.object(forKey: "lblName") as! NSString as String
        
            cell.imgPhoto.layer.cornerRadius = cell.imgPhoto.frame.width/2
            cell.imgPhoto.layer.masksToBounds = true
        
        
            let imageURL = dict.object(forKey: "imgPhoto") as? NSURL
        
            if(imageURL != nil){
                getDataFromUrl(url: imageURL! as URL) { data, response, error in
                    guard let data = data, error == nil else { return }
                
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        if(indexPath.row == 0){
                            cell.imgPhoto.image = UIImage(data: data)
                        }
                        else{
                            cell.imgPhoto.image = self.videoSnapshot(filePathLocal: imageURL!)
                        }
                    }
                }
            }else{
                if(indexPath.row == 0){
                    cell.imgPhoto.image = #imageLiteral(resourceName: "unknownUser")
                }
                else{
                    cell.imgPhoto.image = #imageLiteral(resourceName: "VideoOff")
                }
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fromCell", for: indexPath) as? ReviewTableViewCell else { break }
        
            cell.reviewable = currentCase
            print(currentCase)
        
            cell.selectionStyle = .none
            return cell
        case 2:
            guard currentCase.lovedOnes.count > 0 else {
                return tableView.dequeueReusableCell(withIdentifier: "noneCell", for: indexPath)
            }
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "toCell", for: indexPath) as? ReviewTableViewCell else { break }
        
            cell.reviewable = lovedOnes[indexPath.row]
            print(lovedOnes[indexPath.row])
        
            cell.selectionStyle = .none
            return cell
        
         default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            case 0:
                if(indexPath.row == 0){
                    let reviewController = self.storyboard!.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
                    reviewController.isEditPhoto = true
                    self.navigationController?.pushViewController(reviewController, animated: true)
                } else{
                    let cameraController = self.storyboard!.instantiateViewController(withIdentifier: "cameraViewController") as! CameraViewController
                    self.navigationController?.pushViewController(cameraController, animated: true)
                }
            case 1:
                let bgInfoController = self.storyboard!.instantiateViewController(withIdentifier: "BackgroundInfo1ViewController") as! BackgroundInfo1ViewController
                bgInfoController.mode = .update
                self.navigationController?.pushViewController(bgInfoController, animated: true)
            case 2:
                let bgInfo2Controller = self.storyboard!.instantiateViewController(withIdentifier: "BackgroundInfo2ViewController") as! BackgroundInfo2ViewController
                bgInfo2Controller.mode = .update
                if(lovedOnes[indexPath.row] != nil){
                    bgInfo2Controller.currentLovedOne = lovedOnes[indexPath.row]
                }
                self.navigationController?.pushViewController(bgInfo2Controller, animated: true)
            default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
