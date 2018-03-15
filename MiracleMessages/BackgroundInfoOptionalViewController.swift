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

class BackgroundInfoOptionalViewController: UIViewController {
    let currentCase: Case = Case.current

    // Container to set text why they lost touch with loved ones.
    @IBOutlet weak var mLooseTouchReasonText: UITextView!

    // Container to set reason for homelessness.
    @IBOutlet weak var mHomelessReason: UITextView!
    
    // Handles click of next button on screen.
    @IBAction func onClickNext(_ sender: Any) {
        updateBackgroundInfo()
    }
    
    @IBAction func textField(_ sender: AnyObject) {
        self.view.endEditing(true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWithTap()
        // Set placeholder text
        mLooseTouchReasonText.placeholder = "Answer (optional)"
        mHomelessReason.placeholder = "Answer (optional)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayInfo()
    }
    
    func displayInfo() -> Void {
        if let caseResearch = currentCase.research {
            mLooseTouchReasonText.text = caseResearch.quest1
            mHomelessReason.text = caseResearch.quest2
        }
    }
        
    func updateBackgroundInfo() -> Void {
        currentCase.research = (mLooseTouchReasonText.text, mHomelessReason.text)
    }
}
