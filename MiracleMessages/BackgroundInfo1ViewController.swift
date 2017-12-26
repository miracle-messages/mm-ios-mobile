//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/7/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class BackgroundInfo1ViewController: BackgroundInfoViewController, UIPickerViewDataSource, UIPickerViewDelegate, NVActivityIndicatorViewable{
    
    @IBOutlet weak var container: UIView!
    // Name
    @IBOutlet weak var textFieldClientFirstName: UITextField!
    @IBOutlet weak var textFieldClientMiddleName: UITextField!
    @IBOutlet weak var textFieldClientLastName: UITextField!
    
    // Current Location
    @IBOutlet weak var textFieldCurrentCountry: UITextField!
    @IBOutlet weak var textFieldCurrentState: UITextField!
    @IBOutlet weak var textFieldCurrentCity: UITextField!
    
    // Home Location
    @IBOutlet weak var textFieldHomeCountry: UITextField!
    @IBOutlet weak var textFieldHomeState: UITextField!
    @IBOutlet weak var textFieldHomeCity: UITextField!
    
    // Date of Birth & Age
    @IBOutlet weak var textFieldClientAge: UITextField!
    @IBOutlet weak var switchAgeApproximate: UISwitch!
    
    @IBOutlet weak var textFieldClientDob: UITextField!
    @IBOutlet weak var dobApproximate: UISwitch!
    
    // Partner organizations
    @IBOutlet weak var textFieldPartner: UITextField!
    
    // Contact info
    @IBOutlet weak var textFieldContactInfo: UITextField!
    
    // Time homeless
    @IBOutlet weak var textFieldTimeHomeless: UITextField!
    @IBOutlet weak var textFieldTimeScale: UITextField!
    
    // Notes about the client
    @IBOutlet weak var textViewNotes: UITextField!
    
    let pickerHomeCountry = UIPickerView()
    let pickerHomeState = UIPickerView()
    var keyboardHomeState: UIView?
    var ref: DatabaseReference!
    let pickerCurrentCountry = UIPickerView()
    let pickerCurrentState = UIPickerView()
    var keyboardCurrentState: UIView?
    let pickerPartner = UIPickerView()
    let partners = Partners.instance
    let pickerTimeScale = UIPickerView()
    let datePickerClientDob: UIDatePicker = { _ -> UIDatePicker in
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
        self.hideKeyboardWithTap()

        // Current location
        pickerCurrentCountry.dataSource = self
        pickerCurrentCountry.delegate = self
        textFieldCurrentCountry.inputView = pickerCurrentCountry
        
        pickerCurrentState.dataSource = self
        pickerCurrentState.delegate = self
        keyboardCurrentState = textFieldCurrentState.inputView
        
        // Home location
        pickerHomeCountry.dataSource = self
        pickerHomeCountry.delegate = self
        textFieldHomeCountry.inputView = pickerHomeCountry
        
        pickerHomeState.dataSource = self
        pickerHomeState.delegate = self
        keyboardHomeState = textFieldHomeState.inputView
        
        // Date of Birth
        textFieldClientDob.delegate = self
        textFieldClientDob.inputView = datePickerClientDob
        
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        switchAgeApproximate.transform = transform
        dobApproximate.transform = transform
        
        // Partner
        pickerPartner.dataSource = self
        pickerPartner.delegate = self
        textFieldPartner.inputView = pickerPartner
        
        // Time Scale
        pickerTimeScale.dataSource = self
        pickerTimeScale.delegate = self
        textFieldTimeScale.inputView = pickerTimeScale
        self.textViewNotes.delegate = self
    }
  
    func btnNextTapped(sender: UIBarButtonItem) {
        let needToEnter: (String) -> String = { "You will need to enter " + $0 }
        
        // Client names
        guard textFieldClientFirstName.hasText else {
            alertIncomplete(field: textFieldClientFirstName, saying: needToEnter("the client's first name."))
            return
        }
        guard textFieldClientLastName.hasText else {
            alertIncomplete(field: textFieldClientLastName, saying: needToEnter("the client's last name."))
            return
        }
        
        // Current location
        guard let currentCountry = textFieldCurrentCountry.text else {
            alertIncomplete(field: textFieldCurrentCountry, saying: needToEnter("the client's current country."))
            return
        }
        if Country(rawValue: currentCountry) == .UnitedStates {
            guard textFieldCurrentState.hasText else {
                alertIncomplete(field: textFieldCurrentState, saying: needToEnter("the client's current state."))
                return
            }
        }
        guard textFieldCurrentCity.hasText else {
            alertIncomplete(field: textFieldCurrentCity, saying: needToEnter("the client's current city."))
            return
        }
        
        // Home location
        guard let homeCountry = textFieldHomeCountry.text else {
            alertIncomplete(field: textFieldHomeCountry, saying: needToEnter("the client's home country."))
            return
        }
        if Country(rawValue: homeCountry) == .UnitedStates {
            guard textFieldHomeState.hasText else {
                alertIncomplete(field: textFieldHomeState, saying: needToEnter("the client's home state."))
                return
            }
        }
        guard textFieldHomeCity.hasText else {
            alertIncomplete(field: textFieldHomeCity, saying: needToEnter("the client's home city."))
            return
        }
        // DOB
        guard textFieldClientDob.hasText else{
            alertIncomplete(field: textFieldClientDob, saying: needToEnter("the client's date of birth."))
            return
        }
        // Age
        guard textFieldClientAge.hasText else {
            alertIncomplete(field: textFieldClientAge, saying: needToEnter("the client's age."))
            return
        }
        
        // Contact info
        guard textFieldContactInfo.hasText else {
            alertIncomplete(field: textFieldContactInfo, saying: needToEnter("the client's contact info"))
            return
        }
        
        // Time Homeless
        let alertTimeHomelessString = "the amount of time the client has been without a home"
        guard textFieldTimeHomeless.hasText else {
            alertIncomplete(field: textFieldTimeHomeless, saying: needToEnter(alertTimeHomelessString))
            return
        }
        guard textFieldTimeScale.hasText else {
            alertIncomplete(field: textFieldTimeScale, saying: needToEnter(alertTimeHomelessString))
            return
        }
        
        switch mode {
        case .view:
            self.saveHomelessIndividualFormData(isNext: true)
            return
        case .update:
            self.saveHomelessIndividualFormData(isNext: true)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentCase = Case.current
        displayInfo()
        
        if !textFieldCurrentCountry.hasText {
            pickerCurrentCountry.selectRow(1, inComponent: 0, animated: false)
            pickerView(pickerCurrentCountry, didSelectRow: 1, inComponent: 0)
        }
        
        if !textFieldHomeCountry.hasText {
            pickerHomeCountry.selectRow(1, inComponent: 0, animated: false)
            pickerView(pickerHomeCountry, didSelectRow: 1, inComponent: 0)
        }
        
        self.navigationController?.navigationBar.isHidden = false
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
    
    func saveHomelessIndividualFormData(isNext: Bool){
        self.ShowActivityIndicator()
        let _ = updateBackgroundInfo()
        guard let key = currentCase.key else {return}
        
        let caseStatusReference: DatabaseReference
        caseStatusReference = self.ref.child("/\(cases)/\(key)")
        
        guard let thisCountry = Country(rawValue: textFieldCurrentCountry.text!)
            else { return }
        guard let oldCountry = Country(rawValue: textFieldHomeCountry.text!)
            else { return }
        
        var publicPayload: [String: Any] = [
            "firstName": textFieldClientFirstName.text!,
            "middleName": textFieldClientMiddleName.text!,
            "lastName": textFieldClientLastName.text!,
            "currentCity": textFieldCurrentCity.text!,
            "currentState": textFieldCurrentState.text!,
            "currentCountry": thisCountry.code,
            "homeCity": textFieldHomeCity.text!,
            "homeState": textFieldHomeState.text!,
            "homeCountry": oldCountry.code,
        ]
        
        if let valueString = textFieldTimeHomeless.text, let value = Int(valueString), let typeString = textFieldTimeScale.text, let type = Case.TimeType(rawValue: typeString) {
            let timeHomeless = (type: type, value: value)
            publicPayload["timeHomeless"] = ["type": timeHomeless.type.rawValue, "value": timeHomeless.value] as [String: Any]
        }
        
        if let age = Int(textFieldClientAge.text!) {
            publicPayload["age"] = age
            publicPayload["ageApproximate"] = switchAgeApproximate.isOn
        }
        
        if let partnerName = textFieldPartner.text, let partnerCode = Partners.instance[partnerName] {
            publicPayload["partner"] = ["name": partnerName,
                                        "code":partnerCode]
        }
        
        // Write case data
        caseStatusReference.updateChildValues(publicPayload) { error, _ in
            // If unsuccessful, print and return
            guard error == nil else {
                self.RemoveActivityIndicator()
                self.showAlertView()
                print(error!.localizedDescription)
                Logger.log(error!.localizedDescription)
                Logger.log("\(publicPayload)")
                return
            }
        }
        
        // Private Case
        let privateCaseReference = ref.child("/\(casesPrivate)/\(key)")
        var privatePayload: [String: Any] = [:]
        if let contactInfo = textFieldContactInfo.text {
            privatePayload["contactInfo"] = contactInfo
        }
        
        if let caseNotes = textViewNotes.text{
            privatePayload["notes"] = caseNotes
        }
        
        if let birthdate = textFieldClientDob.text {
            privatePayload["dob"] = DateFormatter.default.string(from: dateFormatter.date(from: birthdate)!)
            privatePayload["dobApproximate"] = dobApproximate.isOn
        }
       
        // If successful, write private case data
        privateCaseReference.updateChildValues(privatePayload) { error, _ in
            self.RemoveActivityIndicator()
            //  If private write unsuccessful, remove case data and return
            guard error == nil else {
                self.showAlertView()
                print(error!.localizedDescription)
                return
            }
            
            if(isNext == true){
              if(self.mode == .update){
                self.delegate?.didFinishUpdating()
                self.navigationController?.popViewController(animated: true)
              } else {
                 self.performSegue(withIdentifier: "BackgroundInfo1ViewController", sender: nil)
              }
            } else{
                if(self.mode == .update){
                    self.delegate?.didFinishUpdating()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func showAlertView(){
        let alert = UIAlertController(title: AppName, message: "Something went wrong. please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func displayInfo() -> Void {
        textFieldClientFirstName.text = currentCase.firstName
        textFieldClientMiddleName.text = currentCase.middleName
        textFieldClientLastName.text = currentCase.lastName
        
        textFieldCurrentCountry.text = currentCase.currentCountry?.name
        textFieldCurrentState.text = currentCase.currentState
        textFieldCurrentCity.text = currentCase.currentCity
        
        textFieldHomeCountry.text = currentCase.homeCountry?.name
        textFieldHomeState.text = currentCase.homeState
        textFieldHomeCity.text = currentCase.homeCity
        
        if let age = currentCase.age { textFieldClientAge.text = String(age) }
        switchAgeApproximate.isOn = currentCase.isAgeApproximate
        if let birthdate = currentCase.dateOfBirth {
            textFieldClientDob.text = dateFormatter.string(from: birthdate)
        }
        dobApproximate.isOn = currentCase.isDOBApproximate
        textFieldPartner.text = currentCase.chapterID
        if let timeHomelessPair = currentCase.timeHomeless {
            textFieldTimeHomeless.text = String(timeHomelessPair.value)
            textFieldTimeScale.text = timeHomelessPair.type.rawValue
        }
        
        textFieldContactInfo.text = currentCase.contactInfo
    }

    func updateBackgroundInfo() -> Case? {
        currentCase.firstName = textFieldClientFirstName.text
        currentCase.middleName = textFieldClientMiddleName.text
        currentCase.lastName = textFieldClientLastName.text

        currentCase.currentCountry = Country(rawValue: textFieldCurrentCountry.text!)
        currentCase.currentState = textFieldCurrentState.text
        currentCase.currentCity = textFieldCurrentCity.text
        
        currentCase.homeCountry = Country(rawValue: textFieldHomeCountry.text!)
        currentCase.homeState = textFieldHomeState.text
        currentCase.homeCity = textFieldHomeCity.text
        
        if let age = Int(textFieldClientAge.text!) {
            currentCase.age = age
            currentCase.isAgeApproximate = switchAgeApproximate.isOn
        }
        
        if let birthdate = textFieldClientDob.text {
            currentCase.dateOfBirth = dateFormatter.date(from: birthdate)
            currentCase.isDOBApproximate = dobApproximate.isOn
        }
        
        if let partner = textFieldPartner.text {
            currentCase.partner = partner
        }
        
        if let contactInfo = textFieldContactInfo.text {
            currentCase.contactInfo = contactInfo
        }
        
        if let valueString = textFieldTimeHomeless.text, let value = Int(valueString), let typeString = textFieldTimeScale.text, let type = Case.TimeType(rawValue: typeString) {
            currentCase.timeHomeless = (type, value)
        }
        
        if let caseNotes = textViewNotes.text{
            currentCase.notes = caseNotes
        }
        
        return currentCase
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _ = updateBackgroundInfo()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let needToEnter: (String) -> String = { "You will need to enter " + $0 }
        
        //  Client names
        guard textFieldClientFirstName.hasText else {
            alertIncomplete(field: textFieldClientFirstName, saying: needToEnter("the client's first name."))
            return false
        }
        guard textFieldClientLastName.hasText else {
            alertIncomplete(field: textFieldClientLastName, saying: needToEnter("the client's last name."))
            return false
        }
        
        //  Current location
        guard let currentCountry = textFieldCurrentCountry.text else {
            alertIncomplete(field: textFieldCurrentCountry, saying: needToEnter("the client's current country."))
            return false
        }
        if Country(rawValue: currentCountry) == .UnitedStates {
            guard textFieldCurrentState.hasText else {
                alertIncomplete(field: textFieldCurrentState, saying: needToEnter("the client's current state."))
                return false
            }
        }
        guard textFieldCurrentCity.hasText else {
            alertIncomplete(field: textFieldCurrentCity, saying: needToEnter("the client's current city."))
            return false
        }
        
        //  Home location
        guard let homeCountry = textFieldHomeCountry.text else {
            alertIncomplete(field: textFieldHomeCountry, saying: needToEnter("the client's home country."))
            return false
        }
        if Country(rawValue: homeCountry) == .UnitedStates {
            guard textFieldHomeState.hasText else {
                alertIncomplete(field: textFieldHomeState, saying: needToEnter("the client's home state."))
                return false
            }
        }
        guard textFieldHomeCity.hasText else {
            alertIncomplete(field: textFieldHomeCity, saying: needToEnter("the client's home city."))
            return false
        }
        // DOB
        guard textFieldClientDob.hasText else{
            alertIncomplete(field: textFieldClientDob, saying: needToEnter("the client's date of birth."))
            return false
        }
        //  Age
        guard textFieldClientAge.hasText else {
            alertIncomplete(field: textFieldClientAge, saying: needToEnter("the client's age."))
            return false
        }
        
        //  Contact info
        guard textFieldContactInfo.hasText else {
            alertIncomplete(field: textFieldContactInfo, saying: needToEnter("the client's contact info"))
            return false
        }
        
        //  Time Homeless
        let alertTimeHomelessString = "the amount of time the client has been without a home"
        guard textFieldTimeHomeless.hasText else {
            alertIncomplete(field: textFieldTimeHomeless, saying: needToEnter(alertTimeHomelessString))
            return false
        }
        guard textFieldTimeScale.hasText else {
            alertIncomplete(field: textFieldTimeScale, saying: needToEnter(alertTimeHomelessString))
            return false
        }
        
        switch mode {
        case .view:
            self.saveHomelessIndividualFormData(isNext: false)
            return true
        case .update:
            self.saveHomelessIndividualFormData(isNext: false)
            return false
        }
    }
    
    func onDatePickerValueChanged(by sender: UIDatePicker) {
        textFieldClientDob.text = dateFormatter.string(from: sender.date)
        if let years = Calendar.current.dateComponents([.year], from: sender.date, to: Date()).year { textFieldClientAge.text = String(years) }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerCurrentCountry, pickerHomeCountry:
            return Country.all.count + 1
        case pickerCurrentState, pickerHomeState:
            return State.all.count + 1
        case pickerPartner:
            return partners.list.count + 1
        case pickerTimeScale:
            return Case.TimeType.all.count + 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerCurrentCountry, pickerHomeCountry:
            guard row != 0 else { return "--"}
            return Country.all[row - 1].rawValue
        case pickerCurrentState, pickerHomeState:
            guard row != 0 else { return "--" }
            return State.all[row - 1].rawValue
        case pickerPartner:
            guard row != 0 else { return "--" }
            return partners.list[row - 1]
        case pickerTimeScale:
            guard row != 0 else { return "--" }
            return Case.TimeType.all[row - 1].rawValue
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerCurrentCountry:
            let text = row == 0 ? "" : Country.all[row - 1].rawValue
            textFieldCurrentCountry.text = text
            textFieldCurrentState.inputView = text == Country.UnitedStates.rawValue ? pickerCurrentState : keyboardCurrentState
        case pickerHomeCountry:
            let text = row == 0 ? "" : Country.all[row - 1].rawValue
            textFieldHomeCountry.text = text
            textFieldHomeState.inputView = text == Country.UnitedStates.rawValue ? pickerHomeState : keyboardHomeState
        case pickerCurrentState, pickerHomeState:
            let text = row == 0 ? "" : State.all[row - 1].rawValue
            (pickerView == pickerCurrentState ? textFieldCurrentState : textFieldHomeState).text = text
        case pickerPartner:
            textFieldPartner.text = row == 0 ? "" : partners.list[row - 1]
        case pickerTimeScale:
            textFieldTimeScale.text = row == 0 ? "" : Case.TimeType.all[row - 1].rawValue
        default:
            return
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == textFieldClientFirstName){
            textFieldClientMiddleName.becomeFirstResponder()
        } else if(textField == textFieldClientMiddleName){
            textFieldClientLastName.becomeFirstResponder()
        } else if(textField == textFieldClientLastName){
            textFieldCurrentCountry.becomeFirstResponder()
        } else if(textField == textFieldCurrentCountry){
            textFieldCurrentState.becomeFirstResponder()
        } else if(textField == textFieldCurrentState){
            textFieldCurrentCity.becomeFirstResponder()
        } else if(textField == textFieldCurrentCity){
            textFieldHomeCountry.becomeFirstResponder()
        } else if(textField == textFieldHomeCountry){
            textFieldHomeState.becomeFirstResponder()
        } else if(textField == textFieldHomeState){
            textFieldHomeCity.becomeFirstResponder()
        } else if(textField == textFieldHomeCity){
            textFieldClientDob.becomeFirstResponder()
        } else if(textField == textFieldClientDob){
            textFieldClientAge.becomeFirstResponder()
        } else if(textField == textFieldClientAge){
            textFieldPartner.becomeFirstResponder()
        } else if(textField == textFieldPartner){
            textFieldContactInfo.becomeFirstResponder()
        } else if(textField == textFieldContactInfo){
            textFieldTimeHomeless.becomeFirstResponder()
        } else if(textField == textFieldTimeHomeless){
            textFieldTimeScale.becomeFirstResponder()
        } else if(textField == textFieldTimeScale){
            textViewNotes.becomeFirstResponder()
        } else if(textField == textViewNotes){
            textViewNotes.resignFirstResponder()
        }
        return true
    }
}
