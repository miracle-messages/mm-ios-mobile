//
//  ViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/25/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
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

