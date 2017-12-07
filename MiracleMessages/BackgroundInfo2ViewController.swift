//
//  BackgroundInfo2ViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/9/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

protocol CameraViewControllerDelegate: class {
    func didFinishRecording(sender: CameraViewController)
}

class BackgroundInfo2ViewController: BackgroundInfoViewController, UIPickerViewDelegate, UIPickerViewDataSource, NVActivityIndicatorViewable, UITextViewDelegate {
   
    var currentLovedOne: LovedOne!
    //  Loved ones
    var lovedOnes: Set<LovedOne> = []
    var ref: DatabaseReference!
    
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
    @IBOutlet weak var textFieldRecipientLastSeenTimeScale: UITextField!
    let pickerTimeScale = UIPickerView()
    
    @IBOutlet weak var textViewRecipientOtherInfo: UITextView!
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var buttonAddAnotherRecipient: UIButton!
    @IBOutlet weak var buttonClearViews: UIButton!
    
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
        
        ref = Database.database().reference()
        hideKeyboardWithTap()

        self.navigationController?.navigationItem.leftBarButtonItem?.title = ""
        
        //  Date of birth
        textFieldRecipientDob.delegate = self
        textFieldRecipientDob.inputView = datePickerRecipientDob
        
        //  Transform for switches
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchRecipientAgeIsApproximate.transform = transform
        switchRecipientDobIsApproximate.transform = transform
        
        pickerTimeScale.delegate = self
        pickerTimeScale.dataSource = self
        textFieldRecipientLastSeenTimeScale.inputView = pickerTimeScale
        
        textViewRecipientOtherInfo.placeholder = "How was the relationship with the loved one before losing contact? Include as many details about the loved one as possible: maiden name, high school, past jobs, college, other family, spouse’s names, etc.."
    }
    
    func btnNextTapped(sender: UIBarButtonItem) {
        self.setBackgroundInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentLovedOne == nil { currentLovedOne = LovedOne() }
        displayInfo()
        
        let isToBeHidden = mode == .update
        buttonClearViews.isHidden = isToBeHidden
        buttonAddAnotherRecipient.isHidden = isToBeHidden
        
        if mode == .update {
            buttonClearViews.isHidden = true
            buttonAddAnotherRecipient.isHidden = true
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(btnNextTapped(sender:)))

    }
    
    //Show activity indicator while saving data
    func ShowActivityIndicator(){
        
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
    
    //Remove activity indicator
    func RemoveActivityIndicator(){
        stopAnimating()
    }
    
    func setBackgroundInfo(){
        
        let needToEnter: (String) -> String = { "You will need to enter " + $0 }
        
        //  Name
        guard textFieldRecipientFirstName.hasText else {
            alertIncomplete(field: textFieldRecipientFirstName, saying: needToEnter("the recipient's first name."))
            return
        }
        guard textFieldRecipientLastName.hasText else {
            alertIncomplete(field: textFieldRecipientLastName, saying: needToEnter("the recipient's last name."))
            return
        }
        
        //  Relationship
        guard textFieldRecipientRelationship.hasText else {
            alertIncomplete(field: textFieldRecipientRelationship, saying: needToEnter("the recipient's relation to the client."))
            return
        }
        
        //  Age
        guard textFieldRecipientAge.hasText, let age = Int(textFieldRecipientAge.text!) else {
            alertIncomplete(field: textFieldRecipientAge, saying: needToEnter("the recipient's age."))
            return
        }
        
        //  Last Contact
        guard textFieldRecipientLastSeen.hasText else {
            alertIncomplete(field: textFieldRecipientLastSeen, saying: needToEnter("the amount of time since the client has seen the recipient."))
            return
        }
        
        //  Notes
        guard textViewRecipientOtherInfo.hasText else {
            alertIncomplete(field: textViewRecipientOtherInfo, saying: needToEnter("some information to help the detectives find this loved one"))
            return
        }
        
        if fieldsAreClear() && currentCase.lovedOnes.count > 0 {
            return
        } else { return self.saveLovedOneFormData(age: age) }
    }
    
    @IBAction func btnNavigateToNextFormClicked(_ sender: Any) {
       self.setBackgroundInfo()
    }
    
    func saveLovedOneFormData(age: Int){
        self.ShowActivityIndicator()
        currentLovedOne.firstName = textFieldRecipientFirstName.text
        currentLovedOne.middleName = textFieldRecipientMiddleName.text ?? ""
        currentLovedOne.lastName = textFieldRecipientLastName.text
        
        currentLovedOne.relationship = textFieldRecipientRelationship.text
        
        currentLovedOne.age = age
        currentLovedOne.isAgeApproximate = switchRecipientAgeIsApproximate.isOn
        if let dateOfBirth = textFieldRecipientDob.text {
            currentLovedOne.dateOfBirth = dateFormatter.date(from: dateOfBirth)
        }
        currentLovedOne.isDOBApproximate = switchRecipientDobIsApproximate.isOn
        
        currentLovedOne.lastKnownLocation = textFieldRecipientLastLocation.text
        
        if let valueString = textFieldRecipientLastSeen.text, let value = Int(valueString), let typeString = textFieldRecipientLastSeenTimeScale.text, let type = Case.TimeType(rawValue: typeString) {
            currentLovedOne.lastContact = (type, value)
        } else { currentLovedOne.lastContact = nil }
        
        
        currentLovedOne.notes = textViewRecipientOtherInfo.text
        
        self.lovedOnes.insert(currentLovedOne)
        self.currentCase.lovedOnes.insert(currentLovedOne)
        
        guard let key = currentCase.key else {return}
        let caseReference: DatabaseReference
        caseReference = self.ref.child("/cases/\(key)")
        
        let privateCaseReference = ref.child("/casesPrivate/\(key)")
        
        //  If successful, write loved ones
        for lovedOne in self.lovedOnes {
            //  Get reference to loved one
            let lovedOneRef = caseReference.child("/lovedOnes/").childByAutoId()
            lovedOne.id = lovedOneRef.key
            
            //  Try to write
            lovedOneRef.setValue(lovedOne.publicInfo) { error, _ in
                //  If unsuccessful return
                guard error == nil else {
                    self.RemoveActivityIndicator()
                    self.showAlertView()
                    print(error!.localizedDescription)
                    return
                }
                
                //  If successful, write private info
                privateCaseReference.child("/lovedOnes/\(lovedOne.id!)").setValue(lovedOne.privateInfo) { error, _ in
                    self.RemoveActivityIndicator()
                    //  If unsuccessful, remove public loved one info
                    guard error == nil else {
                        self.showAlertView()
                        print(error!)
                        lovedOneRef.removeValue()
                        return
                    }
                    print("Loved one successfully written")
                    
                    if(self.mode == .update){
                        self.navigationController?.popViewController(animated: true)
                      //  self.dismiss(animated: true, completion: nil)
                    } else{
                        let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController")
                        self.navigationController?.pushViewController(reviewVC!, animated: true)
                    }
                }
            }
        }
    }
    
    func showAlertView(){
        // create the alert
        let alert = UIAlertController(title: "Miracle Messages", message: "Something went wrong. please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
        if let value = lovedOne.lastContact?.value, let type = lovedOne.lastContact?.type {
            textFieldRecipientLastSeen.text = String(value)
            textFieldRecipientLastSeenTimeScale.text = type.rawValue
        }
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
        clear(sender: sender)
    }
    
    @IBAction func clear(sender: UIButton) {
        for field in textFields {
            field.text = "" }
        textViewRecipientOtherInfo.text = ""
        textFieldRecipientAge.text = ""
        switchRecipientAgeIsApproximate.isOn = false
        switchRecipientDobIsApproximate.isOn = false
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
        
        //  Name
        guard textFieldRecipientFirstName.hasText else {
            alertIncomplete(field: textFieldRecipientFirstName, saying: needToEnter("the recipient's first name."))
            return false
        }
        guard textFieldRecipientLastName.hasText else {
            alertIncomplete(field: textFieldRecipientLastName, saying: needToEnter("the recipient's last name."))
            return false
        }
        
        //  Relationship
        guard textFieldRecipientRelationship.hasText else {
            alertIncomplete(field: textFieldRecipientRelationship, saying: needToEnter("the recipient's relation to the client."))
            return false
        }
        
        //  Age
        guard textFieldRecipientAge.hasText, let age = Int(textFieldRecipientAge.text!) else {
            alertIncomplete(field: textFieldRecipientAge, saying: needToEnter("the recipient's age."))
            return false
        }

        //  Location
//        guard textFieldRecipientLastLocation.hasText else {
//            alertIncomplete(field: textFieldRecipientLastLocation, saying: needToEnter("the recipient's last known location."))
//            return false
//        }
        
        //  Last Contact
        guard textFieldRecipientLastSeen.hasText else {
            alertIncomplete(field: textFieldRecipientLastSeen, saying: needToEnter("the amount of time since the client has seen the recipient."))
            return false
        }
        
        //  Notes
        guard textViewRecipientOtherInfo.hasText else {
            alertIncomplete(field: textViewRecipientOtherInfo, saying: needToEnter("some information to help the detectives find this loved one"))
            return false
        }
        
        currentLovedOne.firstName = textFieldRecipientFirstName.text
        currentLovedOne.middleName = textFieldRecipientMiddleName.text ?? ""
        currentLovedOne.lastName = textFieldRecipientLastName.text
        
        currentLovedOne.relationship = textFieldRecipientRelationship.text
        
        currentLovedOne.age = age
        currentLovedOne.isAgeApproximate = switchRecipientAgeIsApproximate.isOn
        if let dateOfBirth = textFieldRecipientDob.text {
            currentLovedOne.dateOfBirth = dateFormatter.date(from: dateOfBirth)
        }
        currentLovedOne.isDOBApproximate = switchRecipientDobIsApproximate.isOn
        
        currentLovedOne.lastKnownLocation = textFieldRecipientLastLocation.text
        
        if let valueString = textFieldRecipientLastSeen.text, let value = Int(valueString), let typeString = textFieldRecipientLastSeenTimeScale.text, let type = Case.TimeType(rawValue: typeString) {
            currentLovedOne.lastContact = (type, value)
        } else { currentLovedOne.lastContact = nil }
        
        
        currentLovedOne.notes = textViewRecipientOtherInfo.text
        
        currentCase.lovedOnes.insert(currentLovedOne)
        
        return true
    }

  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let _ = self.updateBackgroundInfo()
        // Pass the selected object to the new view controller.
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //  TODO: Figure out what's happening here
        switch mode {
        case .view:
            if fieldsAreClear() && currentCase.lovedOnes.count > 0 {
                return true
            } else { return appendToLovedOnes() }
        default:
            if fieldsAreClear() && currentCase.lovedOnes.count > 0 {
                return true
            } else { return appendToLovedOnes() }
        }
    } */
    
    //  Update values based on picker
    func onDatePickerValueChanged(by sender: UIDatePicker) {
        textFieldRecipientDob.text = dateFormatter.string(from: sender.date)
        if let years = Calendar.current.dateComponents([.year], from: sender.date, to: Date()).year { textFieldRecipientAge.text = String(years) }
    }

    //  Methods for picker views
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Case.TimeType.all.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard row != 0, row <= Case.TimeType.all.count else { return "--" }
        return Case.TimeType.all[row - 1].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldRecipientLastSeenTimeScale.text = row == 0 ? "" : Case.TimeType.all[row - 1].rawValue
    }
}
