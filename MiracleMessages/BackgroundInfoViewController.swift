//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/16/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

struct BackgroundInfo {
    var client_name: String
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
}


protocol Updatable {
    func updateBackgroundInfo() -> BackgroundInfo?
}

extension Updatable {
    func updateBackgroundInfo() -> BackgroundInfo? {
        return nil
    }
}

class BackgroundInfoViewController: ProfileNavigationViewController, UITextFieldDelegate, Updatable {

    @IBOutlet weak var scrollView: UIScrollView!

    var backgroundInfo: BackgroundInfo?
    
    var keyboardIsVisible = false

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

extension BackgroundInfoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
//            self.textViewLabel.isHidden = true
        } else {
//            self.textViewLabel.isHidden = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
//            self.textViewLabel.isHidden = true
        } else {
//            self.textViewLabel.isHidden = false
        }
    }

}
