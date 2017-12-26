//
//  DraftCasesViewController.swift
//  MiracleMessages
//
//  Created by Ved on 05/12/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import NVActivityIndicatorView

class DraftCasesViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var tblCases: UITableView!
    
    var ref: DatabaseReference!
    var arrCases : NSMutableArray!
    var currentCase: Case = Case.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblCases.reloadData()
    }
    
    @IBAction func btnRecordNewVideoClicked(_ sender: Any) {
       let guideVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireGuideView) as! GuideViewController
       self.navigationController?.pushViewController(guideVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DraftCasesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1   // One for Sender, one for Recipients
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: DraftCasesCell! = tableView.dequeueReusableCell(withIdentifier: "DraftCasesCell") as? DraftCasesCell
        if cell == nil {
            tableView.register(UINib(nibName: "DraftCasesCell", bundle: nil), forCellReuseIdentifier: "DraftCasesCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "DraftCasesCell") as? DraftCasesCell
        }
        
        let dict : NSDictionary = self.arrCases[indexPath.row] as! NSDictionary
        let submittedDate = dict.object(forKey: "submittedOn") as! NSString
        
        let strDate = self.convertDate(strDate: submittedDate as String)
        
        cell.lblCaseSubmittedOn.text = NSString(format:"Submitted On: %@", strDate) as String
        cell.lblCaseStatus.text = NSString(format:"Status: %@", dict.object(forKey: "publishStatus") as! NSString) as String
        
        cell.selectionStyle = .none
        return cell
    }
    
    func convertDate(strDate: String) ->  String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: strDate)
              
        let df = DateFormatter()
        df.dateStyle = .medium
        df.dateFormat = "MMM d, yyyy h:mm a"
        if(date != nil){
            let submittedDate = df.string(from: date!)
            return submittedDate
        } else{
            return ""
        }
    }
    
    func updateBackgroundInfo(dictBgInfo: NSDictionary) {
        let dateFormatter = DateFormatter.default
        let firstName = dictBgInfo.object(forKey: "firstName") as? String
      
        if(firstName != ""){
            currentCase.firstName = (dictBgInfo.object(forKey: "firstName") as! String)
            currentCase.middleName = (dictBgInfo.object(forKey: "lastName") as! String)
            currentCase.lastName = (dictBgInfo.object(forKey: "middleName") as! String)

            currentCase.currentCountry = Country(rawValue: dictBgInfo.object(forKey: "currentCountry") as! String)
            currentCase.currentState = (dictBgInfo.object(forKey: "currentState") as! String)
            currentCase.currentCity = (dictBgInfo.object(forKey: "currentCity") as! String)

            currentCase.homeCountry = Country(rawValue: dictBgInfo.object(forKey: "homeCountry") as! String)
            currentCase.homeState = (dictBgInfo.object(forKey: "homeState") as! String)
            currentCase.homeCity = (dictBgInfo.object(forKey: "homeCity") as! String)

            if let age = dictBgInfo.object(forKey: "age") {
                currentCase.age = age as? Int
                currentCase.isAgeApproximate = dictBgInfo.object(forKey: "ageApproximate") as! Bool
            }
        
            if let birthdate = dictBgInfo.object(forKey: "dob") {
                currentCase.dateOfBirth = dateFormatter.date(from: birthdate as! String)
                currentCase.isDOBApproximate = dictBgInfo.object(forKey: "dobApproximate") as! Bool
            }

            let partner = dictBgInfo.object(forKey: "partner") as! NSDictionary
            let partnerName = partner.value(forKey: "name")
        
            if let partner = partnerName {
                currentCase.chapterID = partner as? String
            }

            if let contactInfo = dictBgInfo.object(forKey: "contactInfo") {
                currentCase.contactInfo = contactInfo as! String
            }

            let dictTimeHomeless = dictBgInfo.object(forKey: "timeHomeless") as! NSDictionary
            let typeValue = Case.TimeType(rawValue: dictTimeHomeless.value(forKey: "type") as! String)
            let value = dictTimeHomeless.value(forKey: "value") as! Int
        
            if let type = typeValue {
                currentCase.timeHomeless = (type, value) as (type: Case.TimeType, value: Int)
            }
    
            if let caseNotes = dictBgInfo.object(forKey: "notes"){
                currentCase.notes = caseNotes as! String
            }
        } 
        
        //Background Info 2
        let arrLovedOnes = dictBgInfo.object(forKey: "lovedOnes") as? NSArray
        if let arrLovedOne = arrLovedOnes?.count {
            for lovedOne in arrLovedOnes! {
                let dictLovedOnes = lovedOne as! NSDictionary
                let key = dictLovedOnes.allKeys[0]
                let currentLovedOne: LovedOne = LovedOne()
                //Loved Ones
                let dictCurrentLovedOne = dictLovedOnes.object(forKey: key) as! NSDictionary
                currentLovedOne.id = key as? String
                currentLovedOne.firstName =  (dictCurrentLovedOne.object(forKey: "firstName") as! String)
                currentLovedOne.middleName = (dictCurrentLovedOne.object(forKey: "middleName") as! String)
                currentLovedOne.lastName = (dictCurrentLovedOne.object(forKey: "lastName") as! String)
                currentLovedOne.relationship = (dictCurrentLovedOne.object(forKey: "relationship") as! String)
                currentLovedOne.age = (dictCurrentLovedOne.object(forKey: "age") as! Int)
                currentLovedOne.isAgeApproximate = dictCurrentLovedOne.object(forKey: "ageAppoximate") as! Bool
          
                if let dateOfBirth = (dictBgInfo.object(forKey: "lovedOneDob") as? String) {
                    currentLovedOne.dateOfBirth = dateFormatter.date(from: dateOfBirth)
                }
                
                currentLovedOne.lastKnownLocation = (dictCurrentLovedOne.object(forKey: "lastKnownLocation") as! String)
            
                let dictLastContact = dictCurrentLovedOne.object(forKey: "lastContact") as! NSDictionary
                let typeValue = Case.TimeType(rawValue: dictLastContact.value(forKey: "type") as! String)
                let value = dictLastContact.value(forKey: "value") as! Int
            
                if let type = typeValue {
                    currentLovedOne.lastContact = (type, value)
                }
            
                currentLovedOne.notes = (dictBgInfo.object(forKey: "lovedOneNotes") as? String)
                self.currentCase.lovedOnes.insert(currentLovedOne)
            }
        }
    }
    
    func clearAllCaseData(){
        self.currentCase.firstName = nil
        self.currentCase.lastName = nil
        self.currentCase.middleName = nil
        self.currentCase.currentCountry = nil
        self.currentCase.currentState = nil
        self.currentCase.currentCity = nil
        self.currentCase.homeCountry = nil
        self.currentCase.homeState = nil
        self.currentCase.homeCity = nil
        self.currentCase.dateOfBirth = nil
        self.currentCase.age = nil
        self.currentCase.partner = nil
        self.currentCase.chapterID = nil
        self.currentCase.photoURL = nil
        self.currentCase.lovedOnes.removeAll()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.ShowActivityIndicator()
            let dict : NSDictionary = self.arrCases[indexPath.row] as! NSDictionary
            let caseKey = dict.object(forKey: "caseKey") as! NSString
            
            let ref: DatabaseReference = Database.database().reference()
            ref.child("/\(cases)/").child(caseKey as String).removeValue { (error, ref) in
                if error != nil {
                    print("error \(String(describing: error))")
                }
                
                ref.child("/\(casesPrivate)/").child(caseKey as String).removeValue { (error, ref) in
                    if error != nil {
                        print("error \(String(describing:error))")
                    } else{
                        self.arrCases.removeObject(at:indexPath.row)
                        self.tblCases.reloadData()
                    }
                    self.RemoveActivityIndicator()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict : NSDictionary = self.arrCases[indexPath.row] as! NSDictionary
        let caseKey = dict.object(forKey: "caseKey") as! NSString
        let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireConfirmView) as! ConfirmViewController
        clearAllCaseData()
        self.currentCase.key = caseKey as String
        _ = self.updateBackgroundInfo(dictBgInfo: dict)
        self.navigationController?.pushViewController(confirmVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
    
    func ShowActivityIndicator(){
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
   
    func RemoveActivityIndicator(){
        stopAnimating()
    }
}
