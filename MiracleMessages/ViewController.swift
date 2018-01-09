//
//  ViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/25/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import AVFoundation
import Photos

class ViewController: ProfileNavigationViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad(){
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        handle = Auth.auth().addStateDidChangeListener() {[unowned self] (auth, user) in
            if auth.currentUser == nil {
                self.dismiss(animated: false, completion: nil)
            } else {
                self.verifyProfile()
            }
        }
    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "createProfile" {
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(nav, animated: true)
            /*
            let nav = segue.destination as! UINavigationController
            let webVC = nav.viewControllers[0] as! WebViewController
            webVC.delegate = self
            webVC.urlString = Config.registerUrl
             */
        }
    }
}

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

private extension ViewController {
    func verifyProfile() {
        VolunteerProfile.googleProfileCreated(with: {completed in
            if !completed
            {
                //self.performSegue(withIdentifier: "createProfile", sender: self)
                let nav = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
                self.navigationController?.pushViewController(nav, animated: true)

            } else {
                let statusOfCamera = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                let statusOfMicrophone = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
                let photos = PHPhotoLibrary.authorizationStatus()
                
                if(statusOfCamera == .authorized && statusOfMicrophone == .authorized && photos == .authorized){
                    let startController = self.storyboard!.instantiateViewController(withIdentifier:IdentifireStartView)
                    let nav = UINavigationController(rootViewController: startController)
                    nav.modalPresentationStyle = .overCurrentContext
                    self.present(nav, animated: true, completion: nil)
                } else {
                    let permissionController = self.storyboard!.instantiateViewController(withIdentifier:IdentifirePermissionView)
                    let nav = UINavigationController(rootViewController: permissionController)
                    nav.modalPresentationStyle = .overCurrentContext
                    self.navigationController?.pushViewController(permissionController, animated: true)
                }
            }
        })
    }
}

extension ViewController: WebViewControllerDelegate {
    func didTapCloseBtn(viewController: WebViewController) {
        viewController.dismiss(animated: true, completion: nil)
        verifyProfile()
    }
}
