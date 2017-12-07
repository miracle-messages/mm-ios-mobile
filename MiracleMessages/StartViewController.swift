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

class StartViewController: ProfileNavigationViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var helloLbl: UILabel!
    var ref: DatabaseReference!
    var arrCases : NSMutableArray = NSMutableArray()
    var arrKey : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        resetCaseID()
        displayVolunteerInfo()
        self.getAllPreviousCases()
    }
    
    func getAllPreviousCases(){
        self.ShowActivityIndicator()
     
        ref.child("/cases/").observe(.childAdded, with: { (snapshot) in
            print("snapshot.key --> \(snapshot.key)")
            
            self.arrKey.add(snapshot.key)
            self.RemoveActivityIndicator()
        })
       
    }
    
    @IBAction func btnGetStartedClicked(_ sender: Any) {
        
        let previouscase = DispatchGroup()
        guard let currentUser = Auth.auth().currentUser else { return }
        
            for key in self.arrKey {
                previouscase.enter()
                self.ref?.child("/cases/").child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                   
                    print("Start-->\(snapshot.value)")
                    let dict = snapshot.value as? NSDictionary
                    let createdBy = dict?.object(forKey: "createdBy") as? NSDictionary
                    if(createdBy != nil){
                        let uid = createdBy?.object(forKey: "uid") as! String
                        if(uid == currentUser.uid){
                            if let publishStatus = dict?.object(forKey: "publishStatus") as? String {
                                if(publishStatus == "draft"){
                                    let submittedISO = dict?.object(forKey: "submittedISO") as! String
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
                                    let partnerName = dictPartner?.object(forKey: "partnerName") as? String
                                    
                                    var dictCases: [String: Any] = ["submittedOn":submittedISO,
                                                    "caseKey":snapshot.key,
                                                    "publishStatus":publishStatus,
                                                    "firstName":firstName ?? "",
                                                    "middleName":middleName ?? "",
                                                    "lastName":lastName ?? "",
                                                    "currentCity":currentCity ?? "",
                                                    "currentState": currentState ?? "",
                                                    "currentCountry": currentCountry ?? ""
                                    ]
                                    
//                                    dictCases["currentState"] = currentState ?? ""
//                                    dictCases["currentCountry"] = currentCountry ?? ""
//                                    dictCases["homeCity"] = homeCity ?? ""
//                                    dictCases["homeState"] = homeState ?? ""
//                                    dictCases["homeCountry"] = homeCountry ?? ""
//                                    dictCases["timeHomeless"] = ["type": type ?? "", "value": value ?? 0]
//                                    dictCases["age"] = age
//                                    dictCases["ageApproximate"] = ageApproximate
//                                    dictCases["partner"] = ["partnerName": partnerName ?? ""]
                                    
                                    self.arrCases.add(dictCases)
                                  
                                 }
                            }
                        }
                        print(self.arrCases)
                      
                    }
                    previouscase.leave()
                })
            }
      
        previouscase.notify(queue:DispatchQueue.main) {
            if(self.arrCases.count > 0){
                let draftCasesVC = self.storyboard?.instantiateViewController(withIdentifier: "DraftCasesViewController") as! DraftCasesViewController
                draftCasesVC.arrCases = self.arrCases
                self.navigationController?.pushViewController(draftCasesVC, animated: true)
            } else{
                let guideVC = self.storyboard?.instantiateViewController(withIdentifier: "GuideViewController") as! GuideViewController
                self.navigationController?.pushViewController(guideVC, animated: true)
            }
        }
      
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
