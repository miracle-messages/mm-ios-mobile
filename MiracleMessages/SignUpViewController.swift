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

class SignUpViewController: UIViewController,UITextFieldDelegate
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
    var ref: DatabaseReference!

    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        Btn_IAgree.isSelected = true
        let key = ref.child("users").childByAutoId().key
        let users = ["firstName": txt_FirstName.text! as String,
                     "lastName": txt_LastName.text! as String,
                     "country": txt_Country.text! as String,
                     "city": txt_City.text! as String,
                     "state": txt_State.text! as String,
                     "email": txt_Email.text! as String,
                     "phone": txt_PhoneNumber.text! as String
                    ]
        ref.child("users").child(key).setValue(users)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txt_PhoneNumber.resignFirstResponder()
        
        return true
    }


}
