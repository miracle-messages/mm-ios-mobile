//
//  ReviewViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, CaseDelegate {
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientDobLabel: UILabel!
    @IBOutlet weak var clientLocationLabel: UILabel!
    @IBOutlet weak var clientHometownLabel: UILabel!
    @IBOutlet weak var yearsAwayLabel: UILabel!
    @IBOutlet weak var clientContactLabel: UILabel!
    @IBOutlet weak var clientOtherInfoLabel: UILabel!
    @IBOutlet weak var clientPartnerOrgLabel: UILabel!

    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientRelationshipLabel: UILabel!
    @IBOutlet weak var recipientAgeLabel: UILabel!
    @IBOutlet weak var recipientLocationLabel: UILabel!
    @IBOutlet weak var recipientYearsDisconnectedLabel: UILabel!

    @IBOutlet weak var recipientOtherInfoLabel: UILabel!

    var currentCase: Case?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentCase = Case.current
        displayInfo()
    }

    func displayInfo() -> Void {
        guard let aCase = self.currentCase else { return }
        
        //  Name
        var first = "", middle = "", last = ""
        if let name = aCase.firstName { first = name + " " }
        if let name = aCase.middleName { middle = name + " " }
        if let name = aCase.lastName { last = name }
        clientNameLabel.text = first + middle + last
        
        //  Date of Birth
        if let clientDob = aCase.dateOfBirth {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            clientDobLabel.text = "Date of birth: \(clientDob)\(aCase.isDOBApproximate ? " approx" : "")"
        }
        
        //  Location
        var locations: [String] = []
        if let location = aCase.currentCity { locations.append(location) }
        if let location = aCase.currentState { locations.append(location) }
        if let currentCountry = aCase.currentCountry { locations.append(currentCountry.name) }
        if !locations.isEmpty {
            var location = ""
            for (i, place) in locations.enumerated() { location += place + (i != locations.count - 1 ? ", " : "") }
            clientLocationLabel.text = "Location: \(location)"
        }
        
        //  Hometown
        locations = []
        if let location = aCase.homeCity { locations.append(location) }
        if let location = aCase.homeState { locations.append(location) }
        if let homeCountry = aCase.homeCountry { locations.append(homeCountry.name) }
        if !locations.isEmpty {
            var location = ""
            for (i, place) in locations.enumerated() { location += place + (i != locations.count - 1 ? ", " : "") }
            clientHometownLabel.text = "Location: \(location)"
        }
        
        //  Time homeless
        if let timeHomeless = aCase.timeHomeless {
            yearsAwayLabel.text = "Time away from home: \(timeHomeless.value) \(timeHomeless.type.rawValue)"
        }
        
        //
//        if let clientOtherInfo = aCase.notes {
//            clientOtherInfoLabel.text = "Other info: \(clientOtherInfo)"
//        }
        
        if let clientPartnerOrg = aCase.chapterID {
            clientPartnerOrgLabel.text = "Partner org: \(clientPartnerOrg)"
        }
        
        guard let lovedOne = aCase.lovedOnes.first else { return }
        
        if let recipientName = lovedOne.firstName {
            recipientNameLabel.text = "To: \(recipientName)"
        }
        if let recipientRelationship = lovedOne.relationship {
            recipientRelationshipLabel.text = "Relationship: \(recipientRelationship)"
        }
        if let recipientAge = lovedOne.dateOfBirth {
            recipientAgeLabel.text = "DOB: \(recipientAge)"
        }
        if let recipientLocation = lovedOne.lastKnownLocation {
            recipientLocationLabel.text = "Location: \(recipientLocation)"
        }
        if let recipientYearsDisconnected = lovedOne.lastContact {
            recipientYearsDisconnectedLabel.text = "Years disconnected: \(recipientYearsDisconnected)"
        }
        if let recipientOtherInfo = lovedOne.notes {
            recipientOtherInfoLabel.text = recipientOtherInfo
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cameraViewController" {
            let cameraController = segue.destination as? CameraViewController
            cameraController?.delegate = self
            //cameraController?.backgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
        } else {
            let backgroundController = segue.destination as? BackgroundInfoViewController
            backgroundController?.currentCase = Case.current
            backgroundController?.mode = .update
            backgroundController?.delegate = self
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
    
    func didFinishUpdating() {
        //self.theCase?.save()
        displayInfo()
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
