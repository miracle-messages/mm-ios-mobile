//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/7/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class BackgroundInfo1ViewController: BackgroundInfoViewController {
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
    
    //  Home Location
    @IBOutlet weak var textFieldHomeCountry: UITextField!
    @IBOutlet weak var textFieldHomeState: UITextField!
    @IBOutlet weak var textFieldHomeCity: UITextField!
    
    //  Date of Birth & Age
    @IBOutlet weak var textFieldClientAge: UITextField!
    @IBOutlet weak var switchAgeApproximate: UISwitch!
    
    @IBOutlet weak var textFieldClientDob: UITextField!
    @IBOutlet weak var dobApproximate: UISwitch!
    
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
        
        //  Name
//        textFieldClientFirstName.delegate = self
        
        //  Date of Birth
        textFieldClientDob.delegate = self
        textFieldClientDob.inputView = datePickerClientDob
        
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        switchAgeApproximate.transform = transform
        dobApproximate.transform = transform
        
        //datePickerClientDob.frame.size.height = 0
        
//        textFieldClientCurrentLocation.delegate = self
//        textFieldClientHometown.delegate = self
//        textFieldClientYearsHomeless.delegate = self
//        textViewContactInfo.delegate = self        
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

}
