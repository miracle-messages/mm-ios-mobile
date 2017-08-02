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

class ViewController: ProfileNavigationViewController, GIDSignInUIDelegate {

  var handle: AuthStateDidChangeListenerHandle?

    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //definesPresentationContext = true
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
        if segue.identifier == "createProfile" {
            let nav = segue.destination as! UINavigationController
            let webVC = nav.viewControllers[0] as! WebViewController
            webVC.delegate = self
            webVC.urlString = "https://dev.miraclemessages.org"
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
            if !completed {
                self.performSegue(withIdentifier: "createProfile", sender: self)
            } else {
                let startController = self.storyboard!.instantiateViewController(withIdentifier: "startViewController")
                let nav = UINavigationController(rootViewController: startController)
                nav.modalPresentationStyle = .overCurrentContext
                self.present(nav, animated: true, completion: nil)
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
