//
//  ProfileViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var fullNameTxtfield: UITextField!
    @IBOutlet weak var emailTxtfield: UITextField!
    @IBOutlet weak var phoneTxtfield: UITextField!
    @IBOutlet weak var locationTxtfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let profile: VolunteerProfile = VolunteerProfile(defaults: UserDefaults.standard)

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        
        displayVolunteerInfo()
        self.addDoneButtonOnKeyboard()

        self.fullNameTxtfield.delegate = self
        self.emailTxtfield.delegate = self
        self.phoneTxtfield.delegate = self
        self.locationTxtfield.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        self.emailTxtfield.inputAccessoryView = doneToolbar
        self.fullNameTxtfield.inputAccessoryView = doneToolbar
        self.locationTxtfield.inputAccessoryView = doneToolbar
        self.phoneTxtfield.inputAccessoryView = doneToolbar
    }

    func doneButtonAction(){
        self.emailTxtfield.resignFirstResponder()
        self.fullNameTxtfield.resignFirstResponder()
        self.locationTxtfield.resignFirstResponder()
        self.phoneTxtfield.resignFirstResponder()
    }

    func displayVolunteerInfo() -> Void {
        fullNameTxtfield.text = profile.name
        emailTxtfield.text = profile.email
        phoneTxtfield.text = profile.phone
        locationTxtfield.text = profile.location
    }

    func validate() -> Bool {
        return (fullNameTxtfield.text! != "" || emailTxtfield.text! != "" ||  phoneTxtfield.text! != "" || locationTxtfield.text! != "" )
    }

    @IBAction func didPressSaveBtn(_ sender: Any) {
        if validate() {
            errorLabel.isHidden = true
            let updatedProfile = VolunteerProfile(name: fullNameTxtfield.text!, email: emailTxtfield.text!, phone: phoneTxtfield.text!, location: locationTxtfield.text!)
            updatedProfile.save()
            self.navigationController?.popViewController(animated: true)
        } else {
            errorLabel.isHidden = false
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
