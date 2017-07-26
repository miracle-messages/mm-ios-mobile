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
    var currentLovedOne: LovedOne!
    
    @IBOutlet weak var textFieldRecipientFirstName: UITextField!
    @IBOutlet weak var textFieldRecipientMiddleName: UITextField!
    @IBOutlet weak var textFieldRecipientLastName: UITextField!
    
    @IBOutlet weak var textFieldRecipientRelationship: UITextField!
    
    @IBOutlet weak var textFieldRecipientAge: UITextField!
    @IBOutlet weak var switchRecipientAgeIsApproximate: UISwitch!
    @IBOutlet weak var textFieldRecipientDob: UITextField!
    @IBOutlet weak var switchRecipientDobIsApproximate: UISwitch!
    
    @IBOutlet weak var textFieldRecipientLastLocation: UITextField!
    @IBOutlet weak var textFieldRecipientLastSeen: UITextField!
    
    @IBOutlet weak var textViewRecipientOtherInfo: UITextView!
    
    @IBOutlet var textFields: [UITextField]!
    
    let datePickerRecipientDob: UIDatePicker = { _ -> UIDatePicker in
        var this = UIDatePicker()
        this.datePickerMode = .date
        this.date = Date(timeIntervalSinceReferenceDate: 0)
        this.addTarget(self, action: #selector(onDatePickerValueChanged(by:)), for: .valueChanged)
        return this
    }()
    let dateFormatter = DateFormatter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWithTap()

        self.navigationController?.navigationItem.leftBarButtonItem?.title = ""
        
        //  Date of birth
        textFieldRecipientDob.delegate = self
        textFieldRecipientDob.inputView = datePickerRecipientDob
        
        //  Transform for switches
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchRecipientAgeIsApproximate.transform = transform
        switchRecipientDobIsApproximate.transform = transform
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentLovedOne == nil { currentLovedOne = LovedOne() }
        displayInfo()
    }

    func displayInfo() -> Void {
        guard let lovedOne = currentLovedOne else { return }
        
        textFieldRecipientFirstName.text = lovedOne.firstName
        textFieldRecipientMiddleName.text = lovedOne.middleName
        textFieldRecipientLastName.text = lovedOne.lastName
        
        textFieldRecipientRelationship.text = lovedOne.relationship
        
        if let dateOfBirth = lovedOne.dateOfBirth {
            textFieldRecipientDob.text = dateFormatter.string(from: dateOfBirth)
        }
        switchRecipientDobIsApproximate.isOn = lovedOne.isDOBApproximate
        
        if let age = lovedOne.age {
            textFieldRecipientAge.text = String(age)
        }
        switchRecipientAgeIsApproximate.isOn = lovedOne.isAgeApproximate
        
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
        return self.currentCase
    }
    
    @IBAction func addAnotherLovedOne(sender: UIButton) {
        guard appendToLovedOnes() else { return }
        
        currentLovedOne = LovedOne()
        displayInfo()
    }
    
    @IBAction func clear(sender: UIButton) {
        for field in textFields { field.text = "" }
        textViewRecipientOtherInfo.text = ""
    }
    
    func fieldsAreClear() -> Bool {
        for field in textFields { if field.hasText { return false } }
        return textViewRecipientOtherInfo.hasText
    }
    
    //  Append current loved one to case's loved ones
    /**
     First checks to see if all required fields are filled, and, if so, appends
     fills the `lovedOne`'s properties and adds it to the `Case` object
     
     - Returns: `true` if all items are correctly filled and `lovedOne` is
     appended, `false` otherwise.
     */
    func appendToLovedOnes() -> Bool {
        let needToEnter: (String) -> String = { "You will need to enter " + $0 }
        
        guard textFieldRecipientFirstName.hasText else {
            alertIncomplete(field: textFieldRecipientFirstName, saying: needToEnter("the recipient's first name."))
            return false
        }
        guard textFieldRecipientLastName.hasText else {
            alertIncomplete(field: textFieldRecipientLastName, saying: needToEnter("the recipient's last name."))
            return false
        }
        
        guard textFieldRecipientRelationship.hasText else {
            alertIncomplete(field: textFieldRecipientRelationship, saying: needToEnter("the recipient's relation to the client."))
            return false
        }
        
        guard textFieldRecipientAge.hasText, let age = Int(textFieldRecipientAge.text!) else {
            alertIncomplete(field: textFieldRecipientAge, saying: needToEnter("the recipient's age."))
            return false
        }
        
        guard textFieldRecipientLastLocation.hasText else {
            alertIncomplete(field: textFieldRecipientLastLocation, saying: needToEnter("the recipient's last known location."))
            return false
        }
        
        guard textFieldRecipientLastSeen.hasText else {
            alertIncomplete(field: textFieldRecipientLastSeen, saying: needToEnter("the amount of time since the client has seen the recipient."))
            return false
        }
        
        currentLovedOne.firstName = textFieldRecipientFirstName.text
        currentLovedOne.middleName = textFieldRecipientMiddleName.text ?? ""
        currentLovedOne.lastName = textFieldRecipientLastName.text
        
        currentLovedOne.age = age
        currentLovedOne.isAgeApproximate = switchRecipientAgeIsApproximate.isOn
        if let dateOfBirth = textFieldRecipientDob.text {
            currentLovedOne.dateOfBirth = dateFormatter.date(from: dateOfBirth)
        }
        currentLovedOne.isDOBApproximate = switchRecipientDobIsApproximate.isOn
        
        currentLovedOne.lastKnownLocation = textFieldRecipientLastLocation.text
        currentLovedOne.lastContact = textFieldRecipientLastSeen.text
        currentLovedOne.notes = textViewRecipientOtherInfo.text
        
        currentCase.lovedOnes.insert(currentLovedOne)
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let _ = self.updateBackgroundInfo()
        // Pass the selected object to the new view controller.
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //  TODO: this
        switch mode {
        case .view:
            return true
        default:
            if fieldsAreClear(), currentCase.lovedOnes.count > 0 {
                return true
            } else { return appendToLovedOnes() }
        }
    }
    
    //  Update values based on picker
    func onDatePickerValueChanged(by sender: UIDatePicker) {
        textFieldRecipientDob.text = dateFormatter.string(from: sender.date)
        if let years = Calendar.current.dateComponents([.year], from: sender.date, to: Date()).year { textFieldRecipientAge.text = String(years) }
    }

}
