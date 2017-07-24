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
        displayInfo()
        textFieldRecipientName.delegate = self
        textFieldRecipientRelationship.delegate = self
        textFieldRecipientDob.delegate = self
        textFieldRecipientLastLocation.delegate = self
        textFieldRecipientLastSeen.delegate = self
        textViewRecipientOtherInfo.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayInfo()
    }

    func displayInfo() -> Void {
        guard let clientInfo = self.backgroundInfo else {return}
        guard clientInfo.lovedOnes.count > 0 else { return }
        let lovedOne = clientInfo.lovedOnes[0]
        textFieldRecipientName.text = lovedOne.firstName
        textFieldRecipientRelationship.text = lovedOne.relationship
        textFieldRecipientDob.text = lovedOne.dateOfBirth?.description
        textFieldRecipientLastLocation.text = lovedOne.lastKnownLocation
        textFieldRecipientLastSeen.text = lovedOne.lastContact
        textViewRecipientOtherInfo.text = lovedOne.notes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateBackgroundInfo() -> Case? {
        //  TODO: THIS
        
//        self.backgroundInfo?.recipient_name = self.textFieldRecipientName.text
//        self.backgroundInfo?.recipient_dob = self.textFieldRecipientDob.text
//        self.backgroundInfo?.recipient_relationship = self.textFieldRecipientRelationship.text
//        self.backgroundInfo?.recipient_last_location = self.textFieldRecipientLastLocation.text
//        self.backgroundInfo?.recipient_years_since_last_seen = self.textFieldRecipientLastSeen.text
//        self.backgroundInfo?.recipient_other_info = self.textViewRecipientOtherInfo.text
//        self.backgroundInfo?.save()        
        return self.backgroundInfo
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let _ = self.updateBackgroundInfo()
        // Pass the selected object to the new view controller.
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch mode {
        case .view:
            return true
        default:
            if let clientInfo = self.updateBackgroundInfo() {
                //self.delegate?.clientInfo = clientInfo
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishUpdating()
            })
            return false
        }
    }

}
