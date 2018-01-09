//
//  SignUpViewController.swift
//  MiracleMessages
//
//  Created by Ved on 06/01/18.
//  Copyright © 2018 Win Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var Img_Profile: UIImageView!
    @IBOutlet weak var view_iagree: UIView!
    @IBOutlet weak var txt_FirstName: UITextField!
    @IBOutlet weak var txt_LastName: UITextField!
    @IBOutlet weak var txt_Country: UITextField!
    @IBOutlet weak var txt_City: UITextField!
    @IBOutlet weak var txt_State: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_PhoneNumber: UITextField!
    @IBOutlet weak var Btn_Age: UIButton!
    @IBOutlet weak var Btn_IAgree: UIButton!
    var somedate = String()
    var keyboardCurrentState: UIView?

    let pickerCurrentCountry = UIPickerView()
    let pickerCurrentState = UIPickerView()


    var ref: DatabaseReference!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Current location
        pickerCurrentCountry.dataSource = self
        pickerCurrentCountry.delegate = self
        txt_Country.inputView = pickerCurrentCountry
        
        pickerCurrentState.dataSource = self
        pickerCurrentState.delegate = self
        keyboardCurrentState = txt_State.inputView
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        //let nanosecond = calendar.component(.nanosecond, from: date)
        
        somedate = String(describing:year) + "-" + String(describing:month) + "-" + String(describing:day) + "T" + String(describing:hour) + ":" + String(describing:minutes) + ":" +  String(describing:seconds) //+ ":" + String(describing:nanosecond)
        print(somedate)
        ref = Database.database().reference()
        self.txt_PhoneNumber.delegate = self
        Img_Profile.layer.cornerRadius = 40
        view_iagree.layer.borderWidth = 1
        view_iagree.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func Btn_AgeCick(_ sender: UIButton)
    {
        if Btn_Age.isSelected == true
        {
            Btn_Age.isSelected = false
        }
        else
        {
            Btn_Age.isSelected = true
        }
    }
   
    @IBAction func Btn_IAgreeClick(_ sender: UIButton)
    {
        guard let thisCountry = Country(rawValue: txt_Country.text!)
            else { return }
        
        guard let user = Auth.auth().currentUser else{return}
        Btn_IAgree.isSelected = true
        let users = ["cases": "false",
                     "messages": "false",
                     "missingChapter": "true",
                     "myStory": "",
                     "firstName": txt_FirstName.text! as String,
                     "lastName": txt_LastName.text! as String,
                     "country": thisCountry.code,
                     "city": txt_City.text! as String,
                     "state": txt_State.text! as String,
                     "email": "",
                     "phone": "",
                     "groups": ["volunteer" :""] as [String: Any],
                     "privacyPolicy": somedate,
                     "profileComplete": "true",
                   /*  "profilePhoto" : ,*/
                     "shareEmail": "false",
                     "sharePhone": "false",
                     "positions":["other": "true","otherNote": "Development"] as [String: Any],
                     "termsConditions": somedate,
                     "uid": user.uid as String
            ] as [String : Any]
        ref.child("users").child(user.uid).setValue(users){ error, _ in
        //  If private write unsuccessful, remove case data and return
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        }
        
        let info = ["email": txt_Email.text! as String,
                    "phone": txt_PhoneNumber.text! as String] as [String : Any]
        
        ref.child("usersPrivate").child(user.uid).setValue(info){ error, _ in
            //  If private write unsuccessful, remove case data and return
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txt_PhoneNumber.resignFirstResponder()
        
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerCurrentCountry:
            return Country.all.count + 1
        case pickerCurrentState:
            return State.all.count + 1
        default:
            return 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerCurrentCountry:
            guard row != 0 else { return "--"}
            return Country.all[row - 1].rawValue
        case pickerCurrentState:
            guard row != 0 else { return "--" }
            return State.all[row - 1].rawValue
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerCurrentCountry:
            let text = row == 0 ? "" : Country.all[row - 1].rawValue
            txt_Country.text = text
            txt_State.inputView = text == Country.UnitedStates.rawValue ? pickerCurrentState : keyboardCurrentState
        case pickerCurrentState:
            let text = row == 0 ? "" : State.all[row - 1].rawValue
            (pickerView == pickerCurrentState ? txt_State : txt_State).text = text
        default:
            return
        }
    }


}
