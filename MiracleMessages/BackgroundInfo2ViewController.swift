//
//  BackgroundInfo2ViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/9/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

protocol CameraViewControllerDelegate: class {
    func didFinishRecording(sender: CameraViewController)
}

class BackgroundInfo2ViewController: BackgroundInfoViewController {
    
    @IBOutlet weak var textFieldRecipientName: UITextField!
    @IBOutlet weak var textFieldRecipientRelationship: UITextField!
    @IBOutlet weak var textFieldRecipientDob: UITextField!
    @IBOutlet weak var textFieldRecipientLastLocation: UITextField!
    @IBOutlet weak var textFieldRecipientLastSeen: UITextField!
    @IBOutlet weak var textViewRecipientOtherInfo: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationItem.leftBarButtonItem?.title = ""

        textFieldRecipientName.delegate = self
        textFieldRecipientRelationship.delegate = self
        textFieldRecipientDob.delegate = self
        textFieldRecipientLastLocation.delegate = self
        textFieldRecipientLastSeen.delegate = self
        textViewRecipientOtherInfo.delegate = self
//        let recipientDobPlaceholder = NSAttributedString(string: self.textFieldRecipientDob.placeholder!, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)])
//        self.textFieldRecipientDob.attributedPlaceholder = recipientDobPlaceholder
//        let recipientLastLocationPlaceholder = NSAttributedString(string: self.textFieldRecipientLastLocation.placeholder!, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18)])
//        self.textFieldRecipientLastLocation.attributedPlaceholder = recipientLastLocationPlaceholder
//        let recipientLastSeenPlaceholder = NSAttributedString(string: self.textFieldRecipientLastSeen.placeholder!, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)])
//        self.textFieldRecipientLastSeen.attributedPlaceholder = recipientLastSeenPlaceholder
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateBackgroundInfo() -> BackgroundInfo? {
        self.backgroundInfo?.recipient_name = self.textFieldRecipientName.text
        self.backgroundInfo?.recipient_dob = self.textFieldRecipientDob.text
        self.backgroundInfo?.recipient_relationship = self.textFieldRecipientRelationship.text
        self.backgroundInfo?.recipient_last_location = self.textFieldRecipientLastLocation.text
        self.backgroundInfo?.recipient_years_since_last_seen = self.textFieldRecipientLastSeen.text
        self.backgroundInfo?.recipient_other_info = self.textViewRecipientOtherInfo.text
        self.backgroundInfo?.save()
        return self.backgroundInfo
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let nextController = segue.destination as! ReviewViewController
        nextController.clientInfo = self.updateBackgroundInfo()!

        // Pass the selected object to the new view controller.
    }

}
