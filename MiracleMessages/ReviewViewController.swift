//
//  ReviewViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, CaseDelegate {
    var currentCase: Case = Case.current
    var lovedOnes: [LovedOne] = []
    
    let dateFormatter: DateFormatter = {
        let this = DateFormatter()
        this.dateStyle = .long
        this.timeStyle = .none
        return this
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentCase = Case.current
        lovedOnes = Array(currentCase.lovedOnes)
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
        //  TODO: Check if these are really needed
        
        //self.theCase?.save()
        //displayInfo()
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

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2    //  One for Sender, one for Recipients
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return currentCase.lovedOnes.isEmpty ? 1 : currentCase.lovedOnes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "fromCell", for: indexPath) as? ReviewTableViewCell else { break }
            
            var name = ""
            if let bit = currentCase.firstName { name += bit + " " }
            if let bit = currentCase.middleName { name += bit + " " }
            if let bit = currentCase.lastName { name += bit }
            
            cell.labelName.text = "From: \(name)"
            cell.labelName.updateConstraints()
            
            var data = ""
            
            if let birthdate = currentCase.dateOfBirth { data += "Date of birth: \(dateFormatter.string(from: birthdate))\n" }
            if let age = currentCase.age { data += "Age: \(age)\n" }
            
            var location = ""
            if let city = currentCase.currentCity { location += city }
            if let state = currentCase.currentState { location += (location.isEmpty ? "" : ", ") +  state }
            if let country = currentCase.currentCountry { location += (location.isEmpty ? "" : ", ") + country.name }
            if !location.isEmpty { data += "Location: \(location)\n" }
            
            var homeland = ""
            if let city = currentCase.homeCity { homeland += city }
            if let state = currentCase.homeState { homeland += (location.isEmpty ? "" : ", ") +  state }
            if let country = currentCase.homeCountry { homeland += (location.isEmpty ? "" : ", ") + country.name }
            if !homeland.isEmpty { data += "Hometown: \(homeland)\n" }
            
            if let timeAway = currentCase.timeHomeless {
                data += "Time away from home: \(timeAway.value) \(timeAway.type)"
            }
            
            cell.labelInfo.text = data
            cell.labelInfo.updateConstraints()
            
            return cell
        case 1:
            guard currentCase.lovedOnes.count > 0 else {
                return tableView.dequeueReusableCell(withIdentifier: "noneCell", for: indexPath)
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "toCell", for: indexPath) as? ReviewTableViewCell else { break }
            
            let lovedOne = lovedOnes[indexPath.row]
            
            //  Name
            var name = ""
            
            if let bit = lovedOne.firstName { name += bit + " " }
            if let bit = lovedOne.middleName { name += bit + " " }
            if let bit = lovedOne.lastName { name += bit }
            
            cell.labelName.text = "To: \(name)"
            cell.labelName.updateConstraints()
            
            //  Information
            var data = ""
            
            if let relationship = lovedOne.relationship { data += "Relationship: \(relationship)" }
            
            if let birthdate = lovedOne.dateOfBirth { data += "Date of birth: \(dateFormatter.string(from: birthdate))\n" }
            if let age = currentCase.age { data += "Age: \(age)\n" }
            
            if let location = lovedOne.lastKnownLocation { data += "Location: \(location)\n" }
            
            if let timeApart = lovedOne.lastContact { data += "Last contact: \(timeApart)\n" }
            
            if let notes = lovedOne.notes { data += "Other info: \(notes)" }
            
            cell.labelInfo.text = data
            cell.labelInfo.updateConstraints()
            
            return cell
        default: break
        }
        
        return UITableViewCell()
    }
}
