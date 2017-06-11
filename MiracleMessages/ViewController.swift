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

    var handle: FIRAuthStateDidChangeListenerHandle?

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if FIRAuth.auth()?.currentUser != nil && profileCreated() {
            performSegue(withIdentifier: "loginSummarySegue", sender: self)
        }

        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let defaults = UserDefaults.standard
        if defaults.string(forKey: "name") != nil {
            let startController = storyboard!.instantiateViewController(withIdentifier: "startViewController")
            let nav = UINavigationController(rootViewController: startController)
            nav.modalPresentationStyle = .overCurrentContext
            present(nav, animated: false, completion: nil)
        }

        handle = FIRAuth.auth()?.addStateDidChangeListener() {[unowned self] (auth, user) in
            if auth.currentUser != nil {
                self.performSegue(withIdentifier: "loginSummarySegue", sender: self)
            }
        }
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = handle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification, hidden: false)
    }

    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification, hidden: true)
    }

    func updateBottomLayoutConstraintWithNotification(notification: NSNotification, hidden: Bool) {
        let userInfo = notification.userInfo!

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIViewAnimationOptions.init(rawValue: UInt(rawAnimationCurve))

        if (hidden) {
            bottomLayoutConstraint.constant = 163.0
        } else {
            bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        }

        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState , animationCurve], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSummarySegue" {
            let nav = segue.destination as! UINavigationController
            let webVC = nav.viewControllers[0] as! WebViewController
            webVC.urlString = "https://my.miraclemessages.org"
        }
    }
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


extension UINavigationBar {

    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}

