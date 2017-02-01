//
//  ReviewViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientDobLabel: UILabel!
    @IBOutlet weak var clientLocationLabel: UILabel!
    @IBOutlet weak var clientHometownLabel: UILabel!
    @IBOutlet weak var yearsAwayLabel: UILabel!
    @IBOutlet weak var clientContactLabel: UILabel!

    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientRelationshipLabel: UILabel!
    @IBOutlet weak var recipientAgeLabel: UILabel!
    @IBOutlet weak var recipientLocationLabel: UILabel!
    @IBOutlet weak var recipientYearsDisconnectedLabel: UILabel!

    @IBOutlet weak var recipientOtherInfoLabel: UILabel!

    var clientInfo: BackgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)

    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
        // Do any additional setup after loading the view.
    }

    func displayInfo() -> Void {
        if let clientName = clientInfo.client_name {
            clientNameLabel.text = "From: \(clientName)"
        }
        if let clientDob = clientInfo.client_dob {
            clientDobLabel.text = "Date of birth: \(clientDob)"
        }
        if let clientCurrentCity = clientInfo.client_current_city {
            clientLocationLabel.text = "Location: \(clientCurrentCity)"
        }
        if let clientHometown = clientInfo.client_hometown {
            clientHometownLabel.text = "Hometown: \(clientHometown)"
        }
        if let clientYearsAway = clientInfo.client_years_homeless {
            yearsAwayLabel.text = "Years away from home: \(clientYearsAway)"
        }
        if let clientContact = clientInfo.client_contact_info {
            clientContactLabel.text = clientContact
        }


        if let recipientName = clientInfo.recipient_name {
            recipientNameLabel.text = "To: \(recipientName)"
        }
        if let recipientRelationship = clientInfo.recipient_relationship {
            recipientRelationshipLabel.text = "Relationship: \(recipientRelationship)"
        }
        if let recipientAge = clientInfo.recipient_dob {
            recipientAgeLabel.text = "Age: \(recipientAge)"
        }
        if let recipientLocation = clientInfo.recipient_last_location {
            recipientLocationLabel.text = "Location: \(recipientLocation)"
        }
        if let recipientYearsDisconnected = clientInfo.recipient_years_since_last_seen {
            recipientYearsDisconnectedLabel.text = "Years disconnected: \(recipientYearsDisconnected)"
        }
        if let recipientOtherInfo = clientInfo.recipient_other_info {
            recipientOtherInfoLabel.text = recipientOtherInfo
        }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cameraViewController" {
            let cameraController = segue.destination as? CameraViewController
            cameraController?.delegate = self
            cameraController?.backgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
        } else {
            let backgroundController = segue.destination as? BackgroundInfoViewController
            backgroundController?.backgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "cameraViewController" {
            if !UIImagePickerController.isCameraDeviceAvailable(.rear) {
                let alert = UIAlertController(title: "Cannot access camera.", message: "You will need a rear-view camera to record an interview", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        } else {

            return true
        }
    }

}

extension ReviewViewController: CameraViewControllerDelegate {
    func didFinishRecording(sender: CameraViewController) -> Void {
        guard let navController = self.navigationController else {return}
        for aviewcontroller in navController.viewControllers
        {
            if aviewcontroller is LoginSummaryViewController
            {
                navController.popToViewController(aviewcontroller, animated: true)
            }
        }
    }
}
