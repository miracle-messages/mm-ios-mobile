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

    var ref: FIRDatabaseReference!
//  var handle: FIRAuthStateDidChangeListenerHandle?

    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        definesPresentationContext = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        VolunteerProfile.googleProfileCreated(with: {completed in
            if !completed {
                self.performSegue(withIdentifier: "loginSummarySegue", sender: self)
            } else {
                let startController = self.storyboard!.instantiateViewController(withIdentifier: "startViewController")
                let nav = UINavigationController(rootViewController: startController)
                nav.modalPresentationStyle = .overCurrentContext
                self.present(nav, animated: false, completion: nil)
            }
        })
        

//        handle = FIRAuth.auth()?.addStateDidChangeListener() {[unowned self] (auth, user) in
//            if auth.currentUser != nil {
//                self.performSegue(withIdentifier: "loginSummarySegue", sender: self)
//            }
//        }
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
        if segue.identifier == "loginSummarySegue" {
            let nav = segue.destination as! UINavigationController
            let webVC = nav.viewControllers[0] as! WebViewController
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

