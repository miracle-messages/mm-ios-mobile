//
//  ViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/25/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class ViewController: ProfileNavigationViewController {

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let namePlaceholder = NSAttributedString(string: "Full Name", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        let emailPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        let phonePlaceholder = NSAttributedString(string: "Phone number", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        let locationPlaceholder = NSAttributedString(string: "Location", attributes: [NSForegroundColorAttributeName : UIColor.lightGray])
        self.nameTextField.attributedPlaceholder = namePlaceholder
        self.emailTextField.attributedPlaceholder = emailPlaceholder
        self.phoneTextField.attributedPlaceholder = phonePlaceholder
        self.locationTextField.attributedPlaceholder = locationPlaceholder

        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneTextField.delegate = self
        self.locationTextField.delegate = self
        self.addDoneButtonOnKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        let animationCurve = UIViewAnimationOptions.fromRaw(UInt(rawAnimationCurve))!

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

    func saveCredentials() -> Void {
        let defaults = UserDefaults.standard
        defaults.set(nameTextField.text, forKey: "name")
        defaults.set(emailTextField.text, forKey: "email")
        defaults.set(phoneTextField.text, forKey: "phone")
        defaults.set(locationTextField.text, forKey: "location")
        defaults.synchronize()
    }

    func clearUserInfo() -> Void {
        nameTextField.text = nil
        emailTextField.text = nil
        phoneTextField.text = nil
        locationTextField.text = nil
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ProfileViewController.doneButtonAction))

        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as NSArray as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        self.nameTextField.inputAccessoryView = doneToolbar
        self.emailTextField.inputAccessoryView = doneToolbar
        self.phoneTextField.inputAccessoryView = doneToolbar
        self.locationTextField.inputAccessoryView = doneToolbar
    }

    func doneButtonAction()
    {
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.phoneTextField.resignFirstResponder()
        self.locationTextField.resignFirstResponder()
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

