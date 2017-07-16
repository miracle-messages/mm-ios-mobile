//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/7/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class BackgroundInfo1ViewController: BackgroundInfoViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //  Case
    var currentCase: Case!
    
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
    
    @IBOutlet weak var textFieldPartner: UITextField!
    
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
        
        //  Time Scale
        pickerTimeScale.dataSource = self
        pickerTimeScale.delegate = self
        textFieldTimeScale.inputView = pickerTimeScale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
        displayInfo()
    }

    func displayInfo() -> Void {
        guard let clientInfo = self.backgroundInfo else {return}
//        textFieldClientFirstName.text = clientInfo.client_name
//        textFieldClientDob.text = clientInfo.client_dob
//        textFieldClientCurrentLocation.text = clientInfo.client_current_city
//        textFieldClientHometown.text = clientInfo.client_hometown
//        textFieldClientYearsHomeless.text = clientInfo.client_years_homeless
//        textViewContactInfo.text = clientInfo.client_contact_info
//        textViewOtherInfo.text = clientInfo.client_other_info
    }

    func updateBackgroundInfo() -> BackgroundInfo? {
//        self.backgroundInfo?.client_name = self.textFieldClientFirstName.text
//        self.backgroundInfo?.client_dob = self.textFieldClientDob.text
//        self.backgroundInfo?.client_current_city = self.textFieldClientCurrentLocation.text
//        self.backgroundInfo?.client_hometown = self.textFieldClientHometown.text
//        self.backgroundInfo?.client_contact_info = self.textViewContactInfo.text
//        self.backgroundInfo?.client_years_homeless = self.textFieldClientYearsHomeless.text
//        self.backgroundInfo?.client_other_info = self.textViewOtherInfo.text
//        self.backgroundInfo?.save()        
        return self.backgroundInfo
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _ = self.updateBackgroundInfo()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard !(self.textFieldClientDob.text?.isEmpty)! else {
            let alert = UIAlertController(title: "Cannot continue.", message: "You will need to enter the client's name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        switch mode {
        case .view:
            return true
        default:
            if let clientInfo = self.updateBackgroundInfo() {
                self.delegate?.clientInfo = clientInfo
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishUpdating()
            })
            return false
        }
    }
    
    //  Update values!
    func onDatePickerValueChanged(by sender: UIDatePicker) {
        textFieldClientDob.text = dateFormatter.string(from: sender.date)
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
        case pickerTimeScale:
            textFieldTimeScale.text = row == 0 ? "" : Case.TimeType.all[row - 1].rawValue
        default:
            return
        }
    }

}
