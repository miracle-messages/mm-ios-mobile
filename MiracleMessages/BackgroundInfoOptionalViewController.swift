//
//  BackgroundInfoOptionalViewController.swift
//  MiracleMessages
//
//  This is the screen where optional questions are shown.
//
//  Created by Shobhit on 2017-11-06.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class BackgroundInfoOptionalViewController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate{
    
    @IBOutlet weak var mLooseTouchReasonText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mHomelessReason: UITextField!
    
    let currentCase: Case = Case.current
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        mLooseTouchReasonText.delegate = self
        mHomelessReason.delegate = self
        mLooseTouchReasonText.placeholder = "Answer (optional)"
        mHomelessReason.placeholder = "Answer (optional)"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(btnNextTapped(sender:)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        updateBackgroundInfo(isTopNext:false)
    }

    func keyboardWillShowNotification(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
        }
    }

    func keyboardWillHideNotification(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func btnNextTapped(sender: UIBarButtonItem) {
        self.updateBackgroundInfo(isTopNext:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayInfo() -> Void {
        if let caseResearch = currentCase.research {
            mLooseTouchReasonText.text = caseResearch.quest1
            mHomelessReason.text = caseResearch.quest2
        }
    }
        
    func updateBackgroundInfo(isTopNext: Bool) -> Void {
        self.ShowActivityIndicator()
        currentCase.research = (mLooseTouchReasonText.text, mHomelessReason.text) as? (quest1: String, quest2: String)
        
        var txtmLooseTouchReason : String = ""
        var txtmHomelessReason : String = ""
        
        if let mLooseTouchReason = mLooseTouchReasonText.text{
            txtmLooseTouchReason = mLooseTouchReason
        }
        
        if let mHomelessReason = mHomelessReason.text{
            txtmHomelessReason = mHomelessReason
        }
        
        guard let key = currentCase.key else {return}
        
        let caseReference: DatabaseReference
        caseReference = self.ref.child("/\(cases)/\(key)")
        let publicPayload: [String: Any] = [
            "research":[
                "quest1": txtmLooseTouchReason,
                "quest2": txtmHomelessReason
            ]
        ]
        
        // Write case data
        caseReference.updateChildValues(publicPayload) { error, _ in
            // If unsuccessful, print and return
            self.RemoveActivityIndicator()
            guard error == nil else {
                self.showAlertView()
                print(error!.localizedDescription)
                Logger.log(error!.localizedDescription)
                Logger.log("\(publicPayload)")
                return
            }
            
            if(isTopNext == true){
                self.performSegue(withIdentifier: "backgroundInfoOptional", sender: nil)
            }
        }
    }
     
    func showAlertView(){
        let alert = UIAlertController(title: AppName, message: "Something went wrong. please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func ShowActivityIndicator(){
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
    
    //Remove activity indicator
    func RemoveActivityIndicator(){
        stopAnimating()
    }
}
