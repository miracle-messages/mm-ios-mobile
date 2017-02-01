//
//  ProfileViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let profile: VolunteerProfile = VolunteerProfile(defaults: UserDefaults.standard)

    @IBOutlet weak var fullNameTxtfield: UITextField!
    @IBOutlet weak var emailTxtfield: UITextField!
    @IBOutlet weak var phoneTxtfield: UITextField!
    @IBOutlet weak var locationTxtfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        displayVolunteerInfo()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationItem.leftBarButtonItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        } else {
            errorLabel.isHidden = false
        }
    }


}
