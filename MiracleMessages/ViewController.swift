//
//  ViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/25/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var infoTxtView: UITextView!

    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let namePlaceholder = NSAttributedString(string: "Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        let emailPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        let phonePlaceholder = NSAttributedString(string: "Phone number", attributes: [NSForegroundColorAttributeName : UIColor.white])
        let locationPlaceholder = NSAttributedString(string: "Location", attributes: [NSForegroundColorAttributeName : UIColor.white])
        self.nameTextField.attributedPlaceholder = namePlaceholder
        self.emailTextField.attributedPlaceholder = emailPlaceholder
        self.phoneTextField.attributedPlaceholder = phonePlaceholder
        self.locationTextField.attributedPlaceholder = locationPlaceholder

        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let defaults = UserDefaults.standard
                if defaults.string(forKey: "name") != nil {
                    performSegue(withIdentifier: "loginSummarySegue", sender: self)
                }
    }

    @IBAction func didSelectLoginBtn(_ sender: AnyObject) {
        if (nameTextField.text! == "" || emailTextField.text! == "" ||  phoneTextField.text! == "" || locationTextField.text! == "" ) {
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
            saveCredentials()
            performSegue(withIdentifier: "loginSummarySegue", sender: self)
            clearUserInfo()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        updateBottomLayoutConstraintWithNotification(notification: notification)
        self.toggleInfoView(visible: false)
    }

    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
        self.toggleInfoView(visible: true)
    }

    func toggleInfoView(visible: Bool) -> Void {

        UIView.animate(withDuration: 0.5, animations: {
            if (visible) {
                self.infoTxtView.alpha = 1.0
            } else {
                self.infoTxtView.alpha = 0
            }
        })
    }

    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
//        let animationCurve = UIViewAnimationOptions.fromRaw(UInt(rawAnimationCurve))!

        let animationCurve = UIViewAnimationOptions.init(rawValue: UInt(rawAnimationCurve))

        bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY

        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.beginFromCurrentState , animationCurve], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func saveCredentials() -> Void {
        let defaults = UserDefaults.standard
        defaults.set(nameTextField.text, forKey: "name")
        defaults.set(emailTextField.text, forKey: "email")
        defaults.set(phoneTextField.text, forKey: "phone")
        defaults.set(locationTextField.text, forKey: "location")
    }

    func clearUserInfo() -> Void {
        nameTextField.text = nil
        emailTextField.text = nil
        phoneTextField.text = nil
        locationTextField.text = nil
    }

    

}

