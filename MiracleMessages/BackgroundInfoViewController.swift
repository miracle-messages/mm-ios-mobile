//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/16/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit


protocol CaseDelegate: class {
    var currentCase: Case { get set }
    func didFinishUpdating() -> Void
}

protocol Updatable {
    func updateBackgroundInfo() -> Case?
}

extension Updatable {
    func updateBackgroundInfo() -> Case? {
        return nil
    }
}

enum BackgroundInfoMode {
    case update
    case view
}

class BackgroundInfoViewController: ProfileNavigationViewController, UITextFieldDelegate, Updatable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextBtn: UIButton!

    weak var delegate: CaseDelegate?

    // the Case
    var currentCase: Case!
    
    var keyboardIsVisible = false

    var mode: BackgroundInfoMode = .view

    override func viewDidLoad() {
        super.viewDidLoad()
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets

        switch mode {
        case .update:
            nextBtn.setTitle("Done", for: .normal)
            break
        default:
            nextBtn.setTitle("Next", for: .normal)
            
            break
        }
        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.title = ""
        currentCase = Case.current
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

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch mode {
        case .view:
            return true
        case .update:
            if let clientInfo = self.updateBackgroundInfo() {
                self.delegate?.currentCase = clientInfo
            }
            self.dismiss(animated: true, completion: nil)
            return false
        }
    }
    
    //  Alert for incomplete fields
    func alertIncomplete(field: UIResponder, saying message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .default) { _ in
            field.becomeFirstResponder()
        })
        present(alert, animated: true)
    }

}
