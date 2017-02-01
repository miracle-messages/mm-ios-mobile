//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/16/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

struct BackgroundInfo {
    var client_name: String?
    var client_dob: String?
    var client_current_city: String?
    var client_hometown: String?
    var client_years_homeless: String?
    var client_contact_info: String?
    var recipient_name: String?
    var recipient_relationship: String?
    var recipient_dob: String?
    var recipient_last_location: String?
    var recipient_years_since_last_seen: String?
    var recipient_other_info: String?

    init(client_name: String) {
        self.client_name = client_name
    }

    init(defaults: UserDefaults) {
        if let client_name = defaults.string(forKey: "client_name") {
            self.client_name = client_name
        } else {
            self.client_name = ""
        }
        if let client_dob = defaults.string(forKey: "client_dob") {
            self.client_dob = client_dob
        }
        if let client_current_city = defaults.string(forKey: "client_current_city") {
            self.client_current_city = client_current_city
        }
        if let client_hometown = defaults.string(forKey: "client_hometown") {
            self.client_hometown = client_hometown
        }
        if let client_years_homeless = defaults.string(forKey: "client_years_homeless") {
            self.client_years_homeless = client_years_homeless
        }
        if let client_contact_info = defaults.string(forKey: "client_contact_info") {
            self.client_contact_info = client_contact_info
        }
        if let recipient_name = defaults.string(forKey: "recipient_name")  {
            self.recipient_name = recipient_name
        }
        if let recipient_relationship = defaults.string(forKey: "recipient_relationship") {
            self.recipient_relationship = recipient_relationship
        }
        if let recipient_dob = defaults.string(forKey: "recipient_dob") {
            self.recipient_dob = recipient_dob
        }
        if let recipient_last_location = defaults.string(forKey: "recipient_last_location") {
            self.recipient_last_location = recipient_last_location
        }
        if let recipient_years_since_last_seen = defaults.string(forKey: "recipient_years_since_last_seen") {
            self.recipient_years_since_last_seen = recipient_years_since_last_seen
        }
        if let recipient_other_info = defaults.string(forKey: "recipient_other_info") {
            self.recipient_other_info = recipient_other_info
        }
    }

    func save() -> Void {
        let defaults = UserDefaults.standard
        defaults.set(client_name, forKey: "client_name")
        defaults.set(client_dob, forKey: "client_dob")
        defaults.set(client_current_city, forKey: "client_current_city")
        defaults.set(client_hometown, forKey: "client_hometown")
        defaults.set(client_years_homeless, forKey: "client_years_homeless")
        defaults.set(client_contact_info, forKey: "client_contact_info")
        defaults.set(recipient_name, forKey: "recipient_name")
        defaults.set(recipient_relationship, forKey: "recipient_relationship")
        defaults.set(recipient_dob, forKey: "recipient_dob")
        defaults.set(recipient_last_location, forKey: "recipient_last_location")
        defaults.set(recipient_years_since_last_seen, forKey: "recipient_years_since_last_seen")
        defaults.set(recipient_other_info, forKey: "recipient_other_info")
    }
}


protocol Updatable {
    func updateBackgroundInfo() -> BackgroundInfo?
}

extension Updatable {
    func updateBackgroundInfo() -> BackgroundInfo? {
        return nil
    }
}

enum BackgroundInfoMode {
    case update
    case view
}

class BackgroundInfoViewController: ProfileNavigationViewController, UITextFieldDelegate, Updatable {

    @IBOutlet weak var scrollView: UIScrollView!

    var backgroundInfo: BackgroundInfo?
    
    var keyboardIsVisible = false

    var mode: BackgroundInfoMode = .view

    override func viewDidLoad() {
        super.viewDidLoad()
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

         self.title = ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShowNotification(notification: NSNotification) {

        // get the size of the keyboard
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            keyboardIsVisible = true
        }


    }

    func keyboardWillHideNotification(notification: NSNotification) {
        // get the size of the keyboard
        guard self.keyboardIsVisible else {
            return
        }
        let contentInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        keyboardIsVisible = false
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
