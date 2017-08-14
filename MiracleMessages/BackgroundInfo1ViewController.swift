//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/7/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class BackgroundInfo1ViewController: BackgroundInfoViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //  Container
    @IBOutlet weak var container: UIView!
    
    //  Name
    @IBOutlet weak var textFieldClientFirstName: UITextField!
    @IBOutlet weak var textFieldClientMiddleName: UITextField!
    @IBOutlet weak var textFieldClientLastName: UITextField!
    
    //  Current Location
    @IBOutlet weak var textFieldCurrentCountry: UITextField!
    @IBOutlet weak var textFieldCurrentState: UITextField!
    @IBOutlet weak var textFieldCurrentCity: UITextField!
    
    let pickerCurrentCountry = UIPickerView()
    let pickerCurrentState = UIPickerView()
    var keyboardCurrentState: UIView?
    
    //  Home Location
    @IBOutlet weak var textFieldHomeCountry: UITextField!
    @IBOutlet weak var textFieldHomeState: UITextField!
    @IBOutlet weak var textFieldHomeCity: UITextField!
    
    let pickerHomeCountry = UIPickerView()
    let pickerHomeState = UIPickerView()
    var keyboardHomeState: UIView?
    
    //  Date of Birth & Age
    @IBOutlet weak var textFieldClientAge: UITextField!
    @IBOutlet weak var switchAgeApproximate: UISwitch!
    
    @IBOutlet weak var textFieldClientDob: UITextField!
    @IBOutlet weak var dobApproximate: UISwitch!
    
    //  Partner organizations
    @IBOutlet weak var textFieldPartner: UITextField!
    let pickerPartner = UIPickerView()
    let partners = Partners.instance
    
    //  Time homeless
    @IBOutlet weak var textFieldTimeHomeless: UITextField!
    @IBOutlet weak var textFieldTimeScale: UITextField!
    let pickerTimeScale = UIPickerView()
    
    @IBOutlet weak var textViewNotes: UITextView!
    
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
        currentCase = Case()
        self.hideKeyboardWithTap()
        
        //  Current location
        pickerCurrentCountry.dataSource = self
        pickerCurrentCountry.delegate = self
        textFieldCurrentCountry.inputView = pickerCurrentCountry
        
        pickerCurrentState.dataSource = self
        pickerCurrentState.delegate = self
        keyboardCurrentState = textFieldCurrentState.inputView
        
        //  Home location
        pickerHomeCountry.dataSource = self
        pickerHomeCountry.delegate = self
        textFieldHomeCountry.inputView = pickerHomeCountry
        
        pickerHomeState.dataSource = self
        pickerHomeState.delegate = self
        keyboardHomeState = textFieldHomeState.inputView
        
        //  Date of Birth
        textFieldClientDob.delegate = self
        textFieldClientDob.inputView = datePickerClientDob
        
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        switchAgeApproximate.transform = transform
        dobApproximate.transform = transform
        
        //  Partner
        pickerPartner.dataSource = self
        pickerPartner.delegate = self
        textFieldPartner.inputView = pickerPartner
        
        //  Time Scale
        pickerTimeScale.dataSource = self
        pickerTimeScale.delegate = self
        textFieldTimeScale.inputView = pickerTimeScale

        textViewNotes.placeholder = "How would the client like us to describe their current situation to their loved one,  how we met them; their housing status etc. Any background information on how the client lost contact with their loved ones."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentCase = Case.current
        displayInfo()
    }

    func displayInfo() -> Void {
        //guard let clientInfo = currentCase else {return}
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
    }

    func updateBackgroundInfo() -> Case? {
        currentCase.firstName = textFieldClientFirstName.text
        currentCase.middleName = textFieldClientMiddleName.text
        currentCase.lastName = textFieldClientLastName.text
        
        //  Need not worry about unwrapping as shouldPerformSeque(…) should only return true when the country is supplied
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
        
        if let valueString = textFieldTimeHomeless.text, let value = Int(valueString), let typeString = textFieldTimeScale.text, let type = Case.TimeType(rawValue: typeString) {
            currentCase.timeHomeless = (type, value)
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
        
        //  Age
        guard textFieldClientAge.hasText else {
            alertIncomplete(field: textFieldClientAge, saying: needToEnter("the client's age."))
            return false
        }
        
        //  Partner
        guard textFieldPartner.hasText else {
            alertIncomplete(field: textFieldPartner, saying: needToEnter("the partner organization."))
            return false
        }
        
        switch mode {
        case .view:
            return true
        case .update:
            if self.updateBackgroundInfo() != nil {
                //TODO: Clean up
                //self.delegate?.clientInfo = clientInfo
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishUpdating()
            })
            return false
        }
    }
    
    //  Perform segue
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        
//    }
    
    //  Update values!
    func onDatePickerValueChanged(by sender: UIDatePicker) {
        textFieldClientDob.text = dateFormatter.string(from: sender.date)
        if let years = Calendar.current.dateComponents([.year], from: sender.date, to: Date()).year { textFieldClientAge.text = String(years) }
    }
    
    //  Picker view!
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
            guard row != 0 else { return "--" }
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
        // Update the background info and text fields
        //  TODO: Update the case info!
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

}
