//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/7/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class BackgroundInfoViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var textViewLabel: UILabel!

    @IBOutlet weak var textView: UITextView!
    
    var keyboardIsVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        self.navigationController!.navigationBar.topItem?.backBarButtonItem?.title = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        keyboardIsVisible = false
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
            self.textViewLabel.isHidden = true
        } else {
            self.textViewLabel.isHidden = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            self.textViewLabel.isHidden = true
        } else {
            self.textViewLabel.isHidden = false
        }
    }

}
