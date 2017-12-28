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
        ref = Database.database().reference()
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
        return 1
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
    
    func getCasesData(key : String) {
        self.ShowActivityIndicator()
        
        let dateFormatter = DateFormatter.default
        let previouscase = DispatchGroup()
        let privatecase = DispatchGroup()
        let privateLovedOnecase = DispatchGroup()
       
        previouscase.enter()
        self.ref?.child("/\(cases)/").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? NSDictionary
            if let lovedOnes = dict?.object(forKey: "lovedOnes") as? NSDictionary {
                for key in lovedOnes.allKeys {
                    let currentLovedOne: LovedOne = LovedOne()
                    let dictLovedOnes = lovedOnes.object(forKey: key) as! NSDictionary
                    
                    currentLovedOne.id = key as? String
                    currentLovedOne.firstName = dictLovedOnes.object(forKey: "firstName") as? String ?? ""
                    currentLovedOne.lastName = dictLovedOnes.object(forKey: "lastName") as? String ?? ""
                    currentLovedOne.middleName = dictLovedOnes.object(forKey: "middleName") as? String ?? ""
                    currentLovedOne.relationship =  dictLovedOnes.object(forKey: "relationship") as? String ?? ""
                    currentLovedOne.lastKnownLocation =  dictLovedOnes.object(forKey: "lastKnownLocation") as? String ?? ""
                    currentLovedOne.age =  dictLovedOnes.object(forKey: "age") as? Int ?? 0
                    currentLovedOne.isAgeApproximate =  dictLovedOnes.object(forKey: "ageAppoximate") as? Bool ?? false
                    let dictLastContact =  dictLovedOnes.object(forKey: "lastContact") as! NSDictionary
                    let type =  dictLastContact.object(forKey: "type") as! String
                    let value =  dictLastContact.object(forKey: "value") as! Int
                  
                    let typeValue = Case.TimeType(rawValue: type)
                    if let type = typeValue {
                        currentLovedOne.lastContact = (type, value)
                    }
                    
                    privateLovedOnecase.enter()
                    self.ref?.child("/\(casesPrivate)/").child(snapshot.key).child("lovedOnes").child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        let dict = snapshot.value as? NSDictionary
                        let dob =  dict?.object(forKey: "dob") as! String
                        
                        currentLovedOne.dateOfBirth = dateFormatter.date(from: dob)
                        currentLovedOne.isDOBApproximate = dict?.object(forKey: "dobApproximate") as? Bool ?? false
                        currentLovedOne.notes = dict?.object(forKey: "notes") as? String ?? ""
                        privateLovedOnecase.leave()
                    })
                    
                    privateLovedOnecase.notify(queue:DispatchQueue.main) {
                        self.currentCase.lovedOnes.insert(currentLovedOne)
                    }
                }
            }
            
            self.currentCase.firstName = dict?.object(forKey: "firstName") as? String ?? ""
            self.currentCase.middleName = dict?.object(forKey: "middleName") as? String ?? ""
            self.currentCase.lastName = dict?.object(forKey: "lastName") as? String ?? ""
            self.currentCase.currentCity = dict?.object(forKey: "currentCity") as? String ?? ""
            self.currentCase.currentState = dict?.object(forKey: "currentState") as? String ?? ""
            let currentCountry = dict?.object(forKey: "currentCountry") as? String
            self.currentCase.currentCountry = Country(rawValue: currentCountry ?? "")
            self.currentCase.homeCity = dict?.object(forKey: "homeCity") as? String ?? ""
            self.currentCase.homeState = dict?.object(forKey: "homeState") as? String ?? ""
            let homeCountry = dict?.object(forKey: "homeCountry") as? String
            self.currentCase.homeCountry = Country(rawValue: homeCountry ?? "")
            
            //age
            self.currentCase.age = dict?.object(forKey: "age") as? Int ?? 0
            self.currentCase.isAgeApproximate = dict?.object(forKey: "ageApproximate") as? Bool ?? false
            
            //partner
            let dictPartner = dict?.object(forKey: "partner") as? NSDictionary
            self.currentCase.chapterID = dictPartner?.object(forKey: "name") as? String ?? ""
  
            //timehomeless
            let timeHomeless = dict?.object(forKey: "timeHomeless") as? NSDictionary
            let type = timeHomeless?.object(forKey: "type") as? String
            let value = timeHomeless?.object(forKey: "value") as? Int
            let typeValue = Case.TimeType(rawValue: type ?? "")
            let homeValue = value ?? 0
            self.currentCase.timeHomeless = (typeValue, homeValue) as? (type: Case.TimeType, value: Int)
            
            privatecase.enter()
            self.ref?.child("/\(casesPrivate)/").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    self.currentCase.contactInfo = dict?.object(forKey: "contactInfo") as? String ?? ""
                    self.currentCase.notes = dict?.object(forKey: "notes") as? String ?? ""
                    let dob = dict?.object(forKey: "dob") as? String
                    self.currentCase.dateOfBirth = dateFormatter.date(from: dob!)
                
                    if let dobApproximate = dict?.object(forKey: "dobApproximate") as? Bool{
                        self.currentCase.isDOBApproximate = dobApproximate
                    } else {
                        self.currentCase.isDOBApproximate = false
                    }
                
                    privatecase.leave()
                })
            
            privatecase.notify(queue:DispatchQueue.main) {
                previouscase.leave()
            }
         })
        
        previouscase.notify(queue:DispatchQueue.main) {
            self.RemoveActivityIndicator()
            let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireConfirmView) as! ConfirmViewController
            self.navigationController?.pushViewController(confirmVC, animated: true)
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
        clearAllCaseData()
        self.currentCase.key = caseKey as String
        self.getCasesData(key: caseKey as String)
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
