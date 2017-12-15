//
//  StartViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/10/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import NVActivityIndicatorView

class StartViewController: ProfileNavigationViewController, NVActivityIndicatorViewable, UIWebViewDelegate{

    @IBOutlet weak var helloLbl: UILabel!
    var ref: DatabaseReference!
    var arrCases : NSMutableArray!
    var arrKey : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        resetCaseID()
        displayVolunteerInfo()
        self.getAllPreviousCases()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arrCases = NSMutableArray()
    }
    
    func getAllPreviousCases(){
        self.ShowActivityIndicator()
     
        ref.child("/cases/").observe(.childAdded, with: { (snapshot) in
            self.arrKey.add(snapshot.key)
            self.RemoveActivityIndicator()
        })
       
    }
    
    func createWebViewController(withUrl: String) -> WebViewController {
        let webController: WebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webViewController") as! WebViewController
        webController.urlString = withUrl
        return webController
    }
    
    func loadWebview(){
        let viewController = self.createWebViewController(withUrl: "https://dev.miraclemessages.org")
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnGetStartedClicked(_ sender: Any) {
        self.loadWebview()
        
        /*self.ShowActivityIndicator()
        let previouscase = DispatchGroup()
        let privatecase = DispatchGroup()
        guard let currentUser = Auth.auth().currentUser else { return }

            for key in self.arrKey {
                previouscase.enter()
                let arrLovedOnes: NSMutableArray = NSMutableArray()
                self.ref?.child("/cases/").child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    let createdBy = dict?.object(forKey: "createdBy") as? NSDictionary
                    if(createdBy != nil){
                        let uid = createdBy?.object(forKey: "uid") as! String
                        if(uid == currentUser.uid){
                            if let publishStatus = dict?.object(forKey: "publishStatus") as? String {
                                if(publishStatus == "draft"){
                                    
                                    if let lovedOnes = dict?.object(forKey: "lovedOnes") as? NSDictionary {
                                        
                                        for key in lovedOnes.allKeys {
                                                                    
                                            let dictInvitedFriend = lovedOnes.object(forKey: key) as! NSDictionary
                                            let firstName =  dictInvitedFriend.object(forKey: "firstName") as! String
                                            let lastName =  dictInvitedFriend.object(forKey: "lastName") as! String
                                            let middleName =  dictInvitedFriend.object(forKey: "middleName") as! String
                                            let relationship =  dictInvitedFriend.object(forKey: "relationship") as! String
                                            let lastKnownLocation =  dictInvitedFriend.object(forKey: "lastKnownLocation") as! String
                                            let age =  dictInvitedFriend.object(forKey: "age") as! Int
                                            let ageAppoximate =  dictInvitedFriend.object(forKey: "ageAppoximate") as! Bool
                                            let dictLastContact =  dictInvitedFriend.object(forKey: "lastContact") as! NSDictionary
                                            let type =  dictLastContact.object(forKey: "type") as! String
                                            let value =  dictLastContact.object(forKey: "value") as! Int
                                            
                                            let dictLovedCases: [String: Any] = [
                                                "age":age,
                                                "ageAppoximate":ageAppoximate,
                                                "firstName":firstName,
                                                "lastContact":["type": type, "value":value],
                                                "lastKnownLocation":lastKnownLocation,
                                                "lastName":lastName,
                                                "middleName":middleName,
                                                "relationship":relationship,
                                            ]
                                            
                                            let dict: [String: Any] = [key as! String: dictLovedCases]
                                            arrLovedOnes.add(dict)
                                        }
                                        
                                    }
                                    
                                    let submittedISO = dict?.object(forKey: "created") as? String
                                    let firstName = dict?.object(forKey: "firstName") as? String
                                    let middleName = dict?.object(forKey: "middleName") as? String
                                    let lastName = dict?.object(forKey: "lastName") as? String
                                    let currentCity = dict?.object(forKey: "currentCity") as? String
                                    let currentState = dict?.object(forKey: "currentState") as? String
                                    let currentCountry = dict?.object(forKey: "currentCountry") as? String
                                    let homeCity = dict?.object(forKey: "homeCity") as? String
                                    let homeState = dict?.object(forKey: "homeState") as? String
                                    let homeCountry = dict?.object(forKey: "homeCountry") as? String
                                    //timehomeless
                                    let timeHomeless = dict?.object(forKey: "timeHomeless") as? NSDictionary
                                    let type = timeHomeless?.object(forKey: "type") as? String
                                    let value = timeHomeless?.object(forKey: "value") as? Int
                                    //age
                                    let age = dict?.object(forKey: "age") as? Int
                                    let ageApproximate = dict?.object(forKey: "ageApproximate") as? Bool
                                    //partner
                                    let dictPartner = dict?.object(forKey: "partner") as? NSDictionary
                                    let partnerName = dictPartner?.object(forKey: "name") as? String
                                    let partnerCode = dictPartner?.object(forKey: "code") as? String
                                    
                                    var dictCases: [String: Any] = ["submittedOn":submittedISO ?? "",
                                                    "caseKey":snapshot.key,
                                                    "publishStatus":publishStatus,
                                                    "firstName":firstName ?? "",
                                                    "middleName":middleName ?? "",
                                                    "lastName":lastName ?? "",
                                                    "currentCity":currentCity ?? "",
                                                    "currentState": currentState ?? "",
                                                    "currentCountry": currentCountry ?? "",
                                                    "homeCity": homeCity ?? "",
                                                    "homeState": homeState ?? "",
                                                    "homeCountry": homeCountry ?? "",
                                                    "timeHomeless": ["type": type ?? "", "value": value ?? 0],
                                                    "age": age ?? 0,
                                                    "ageApproximate": ageApproximate ?? false,
                                                    "partner": ["name": partnerName ?? "",  "code": partnerCode ?? ""]
                                    ]
                                    
                                    privatecase.enter()
                                    self.ref?.child("/casesPrivate/").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in

                                        let dict = snapshot.value as? NSDictionary
                                        let contactInfo = dict?.object(forKey: "contactInfo") as? String
                                        let notes = dict?.object(forKey: "notes") as? String
                                        let dob = dict?.object(forKey: "dob") as? String
                                        let dobApproximate = dict?.object(forKey: "dobApproximate") as? Bool

                                        dictCases["contactInfo"] = contactInfo
                                        dictCases["notes"] = notes
                                        dictCases["dob"] = dob
                                        dictCases["dobApproximate"] = dobApproximate
                                        if(arrLovedOnes.count > 0) {
                                            dictCases["lovedOnes"] = arrLovedOnes
                                        }
                                        
                                        if let lovedOnes = dict?.object(forKey: "lovedOnes") as? NSDictionary {
                                            for key in lovedOnes.allKeys {
                                                let dict = lovedOnes.object(forKey: key) as! NSDictionary
                                                let dob =  dict.object(forKey: "dob") as! String
                                                let notes =  dict.object(forKey: "notes") as! String
                                                dictCases["lovedOneDob"] = dob
                                                dictCases["lovedOneNotes"] = notes
                                            }
                                        }
                                        
                                        self.arrCases.add(dictCases)
                                        privatecase.leave()
                                    })
                                 }
                            }
                        }
                    }
                    privatecase.notify(queue:DispatchQueue.main) {
                        previouscase.leave()
                    }
                })
            }
      
        previouscase.notify(queue:DispatchQueue.main) {
            self.RemoveActivityIndicator()
            if(self.arrCases.count > 0){
                let draftCasesVC = self.storyboard?.instantiateViewController(withIdentifier: "DraftCasesViewController") as! DraftCasesViewController
                draftCasesVC.arrCases = NSMutableArray()
                draftCasesVC.arrCases = self.arrCases
                self.navigationController?.pushViewController(draftCasesVC, animated: true)
            } else{
                let guideVC = self.storyboard?.instantiateViewController(withIdentifier: "GuideViewController") as! GuideViewController
                self.navigationController?.pushViewController(guideVC, animated: true)
            }
        }
      */
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
    
    func resetCaseID() {
        UserDefaults.standard.removeObject(forKey: Keys.caseID)
    }

    func displayVolunteerInfo() -> Void {
        let defaults = UserDefaults.standard

        let fullName = defaults.string(forKey: "name")

        if let fullNameArr = fullName?.components(separatedBy: " ") {
            helloLbl.text = "Hello \(fullNameArr[0]),"
        }
    }

}
