//
//  PermissionViewController.swift
//  MiracleMessages
//
//  Created by Ved on 29/12/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class PermissionViewController: UIViewController {

    @IBOutlet weak var btnCameraAccess: UIButton!
    @IBOutlet weak var btnMicrophoneAccess: UIButton!
    @IBOutlet weak var btnGalleryAccess: UIButton!
    @IBOutlet weak var btnNext: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setButtonLayoutWhite(btn: btnCameraAccess)
        self.setButtonLayoutWhite(btn: btnMicrophoneAccess)
        self.setButtonLayoutWhite(btn: btnGalleryAccess)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.btnNext.isHidden = false
         self.checkPermission()
    }
    
    func checkPermission(){
        // Check Camera Permission
        let statusOfCamera = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if statusOfCamera == .authorized {
            self.setButtonLayoutBlack(btn: self.btnCameraAccess)
        } else {
            self.setButtonLayoutWhite(btn: self.btnCameraAccess)
        }
        
        // Check Microphone Permission
        let statusOfMicrophone = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        if statusOfMicrophone == .authorized {
            self.setButtonLayoutBlack(btn: self.btnMicrophoneAccess)
        } else {
            self.setButtonLayoutWhite(btn: self.btnMicrophoneAccess)
        }
        
        // Check Gallery Permission
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .authorized {
            self.setButtonLayoutBlack(btn: self.btnGalleryAccess)
        }  else {
            self.setButtonLayoutWhite(btn: self.btnGalleryAccess)
        }
        
        if(statusOfCamera == .authorized && statusOfMicrophone == .authorized && photos == .authorized){
            self.btnNext.isHidden = false
        }
    }
    
    func setButtonLayoutBlack(btn: UIButton){
        btn.backgroundColor = UIColor.black
        btn.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
        btn.titleEdgeInsets.left = 10
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        
        let statusOfCamera = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        let statusOfMicrophone = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if(statusOfCamera == .authorized && statusOfMicrophone == .authorized && photos == .authorized){
            self.btnNext.isHidden = false
        }
    }
    
    func setButtonLayoutWhite(btn: UIButton){
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.5
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.setTitleColor(UIColor.black, for: .normal)
    }
    
    func openSettingsApp(){
        if let appSettingsURL = NSURL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(appSettingsURL as URL)
        }
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        let startController = self.storyboard!.instantiateViewController(withIdentifier: IdentifireStartView)
        let nav = UINavigationController(rootViewController: startController)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }
  
    @IBAction func btnCameraAccessClicked(_ sender: Any) {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if (status == .notDetermined) {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { response in
                if response {
                    DispatchQueue.main.async {
                        self.setButtonLayoutBlack(btn: self.btnCameraAccess)
                    }
                }
            }
        } else if (status == .authorized) {
            self.setButtonLayoutBlack(btn: self.btnCameraAccess)
        } else if status == .restricted || status == .denied {
            self.openSettingsApp()
        }
    }
    
    @IBAction func btnMicrophoneAccessClicked(_ sender: Any) {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
       
        if (status == .notDetermined) {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio) { response in
                print(response)
                if response {
                    DispatchQueue.main.async {
                        self.setButtonLayoutBlack(btn: self.btnMicrophoneAccess)
                    }
                }
            }
        } else if status == .restricted || status == .denied {
            self.openSettingsApp()
        } else if (status == .authorized) {
            self.setButtonLayoutBlack(btn: self.btnMicrophoneAccess)
        }
    }
    
    @IBAction func btnGalleryAccessClicked(_ sender: Any) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    DispatchQueue.main.async {
                        self.setButtonLayoutBlack(btn: self.btnGalleryAccess)
                    }
                }
            })
        } else if photos == .authorized {
             self.setButtonLayoutBlack(btn: self.btnGalleryAccess)
        } else if photos == .restricted || photos == .denied {
            self.openSettingsApp()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
