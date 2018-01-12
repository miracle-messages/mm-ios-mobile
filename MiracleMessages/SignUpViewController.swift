
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

class SignUpViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var ScrollView: UIScrollView!
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
    @IBOutlet weak var activeTextField: UITextField?

    
    @IBOutlet weak var lbl_msg: UILabel!
    var somedate = String()
    var profilephoto = String()
    var temp = String()
    var userPhoto = String()
    
    let pickerCurrentCountry = UIPickerView()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        guard let user = Auth.auth().currentUser else {return}
        let Profilepic = user.photoURL
        let data = try? Data(contentsOf: Profilepic!)
        let profilephoto = String(describing:Profilepic)
        Img_Profile.image = UIImage(data: data!)
        let temp = profilephoto.dropFirst(9)
        let temp1 = temp.dropLast(1)
        userPhoto = String(temp1)
        
        //Hide keybord when user click on view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Create iso string
        let stringFromDate = Date().iso8601    // "2017-03-22T13:22:13.933Z"
        somedate = String(describing:stringFromDate)
        
        // Current location
        pickerCurrentCountry.dataSource = self
        pickerCurrentCountry.delegate = self
        txt_Country.inputView = pickerCurrentCountry
        
        ref = Database.database().reference()
        // self.txt_PhoneNumber.delegate = self
        Img_Profile.layer.cornerRadius = 40
        view_iagree.layer.borderWidth = 1
        view_iagree.layer.borderColor = UIColor.black.cgColor
        
        //text field delegate
        textDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // call method for keyboard notification
        self.setNotificationKeyboard()
    }
    
    @IBAction func End_Editing(_ sender: UITextField) {
        let country = txt_Country.text
        if country == "United States"{
            lbl_msg.text = "###-###-####"
        }
        else{
            lbl_msg.text = "Use your country code and your number without seperators or symbols"
        }
    }

    // Notification when keyboard show
    func setNotificationKeyboard ()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    //will Display keyboard
    func keyboardWasShown(notification: NSNotification)
    {
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height+10, 0.0)
        self.ScrollView.contentInset = contentInsets
        self.ScrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeTextField
        {
            if (!aRect.contains(activeField.frame.origin))
            {
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    // when keyboard hide reduce height of scroll view
    func keyboardWillBeHidden(notification: NSNotification){
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,0.0, 0.0)
        self.ScrollView.contentInset = contentInsets
        self.ScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    //set textfield delegate
    func textDelegate()
    {
        self.txt_PhoneNumber.delegate = self
        self.txt_FirstName.delegate = self
        self.txt_LastName.delegate = self
        self.txt_City.delegate = self
        self.txt_State.delegate = self
        self.txt_Country.delegate = self
        self.txt_Email.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func Btn_AgeCick(_ sender: UIButton){
        Btn_Age.isSelected = true
    }
    
    @IBAction func Btn_IAgreeClick(_ sender: UIButton){
        if Btn_Age.isSelected == true {
            txtvalid()
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Only volunteers over the age of 13 can sign up for our volunteer services.", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func AddData(){
        guard let user = Auth.auth().currentUser else{return}
        Btn_IAgree.isSelected = true
        let users = ["cases": "false",
                     "messages": "false",
                     "missingChapter": "true",
                     "myStory": "",
                     "firstName": txt_FirstName.text! as String,
                     "lastName": txt_LastName.text! as String,
                     "country": txt_Country.text! as String,
                     "city": txt_City.text! as String,
                     "state": txt_State.text! as String,
                     "profilePhoto": userPhoto,
                     "email": "",
                     "phone": "",
                     "groups": ["volunteer": ""],
                     "privacyPolicy": somedate,
                     "profileComplete": "true",
                     "shareEmail": "false",
                     "sharePhone": "false",
                     "positions": ["other": "true",
                                   "otherNote": "Development"],
                     "termsConditions": somedate,
                     "uid": user.uid as String
            ] as [String : Any]
        
        let info = ["email": txt_Email.text! as String,
                    "phone": txt_PhoneNumber.text! as String
        ]
        
        ref.child("users").child(user.uid).setValue(users){ error, _ in
            //  If private write unsuccessful, remove case data and return
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        ref.child("usersPrivate").child(user.uid).setValue(info){ error, _ in
            //  If private write unsuccessful, remove case data and return
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        
        let nav = self.storyboard?.instantiateViewController(withIdentifier: "PermissionViewController")as! PermissionViewController
        navigationController?.pushViewController(nav, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txt_FirstName){
            txt_LastName.becomeFirstResponder()
        } else if(textField == txt_LastName){
            txt_Country.becomeFirstResponder()
        } else if(textField == txt_Country){
            txt_City.becomeFirstResponder()
        } else if(textField == txt_City){
            txt_State.becomeFirstResponder()
        } else if(textField == txt_State){
            txt_Email.becomeFirstResponder()
        } else if(textField == txt_Email){
            txt_PhoneNumber.becomeFirstResponder()
        } else if(textField == txt_PhoneNumber){
            txt_Email.resignFirstResponder()
        }
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerCurrentCountry:
            return Country.all.count + 1
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
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerCurrentCountry:
            let text = row == 0 ? "" : Country.all[row - 1].rawValue
            txt_Country.text = text
        default:
            return
        }
    }
    
    //Email Validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: txt_Email.text)
    }
    
    
    //Phone Validation
    func isValidPhone(testStr:String) -> Bool {
        if txt_Country.text == "United States"
        {
            let numberRegEx = "[0-9]{3}+[-]+[0-9]{3}+[-]+[0-9]{4}"
            let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            return numberTest.evaluate(with: txt_PhoneNumber.text)
        }
        else
        {
            let numberRegEx = "[0-9]{10}"
            let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            return numberTest.evaluate(with: txt_PhoneNumber.text)
        }
    }
    
    
    //checking textfields are valid not
    func txtvalid(){
        if isValidEmail(testStr: txt_Email.text!) != true{
            let alert = UIAlertController(title: "Alert", message: "Enter valid Email.", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if isValidPhone(testStr: txt_PhoneNumber.text!) != true{
            if txt_Country.text == "United States"
            {
                let alert = UIAlertController(title: "Alert", message: "Example,Phone number : 111-222-3333", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "Phone number shold be 10 digit.", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else if txt_FirstName.text == "" || txt_LastName.text == "" || txt_Country.text == "" || txt_State.text == "" || txt_Email.text == "" || txt_PhoneNumber.text == "" || txt_City.text == "" {
            let alert = UIAlertController(title: "Alert", message: "Please enter all fields.", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            AddData()
        }
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}


