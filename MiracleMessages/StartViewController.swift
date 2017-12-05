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
        print("currentUser id --> \(currentUser.uid)")
        
            for key in self.arrKey {
                previouscase.enter()
                self.ref?.child("/cases/").child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                   
                    print(snapshot.value)
                    let dict = snapshot.value as? NSDictionary
                    let createdBy = dict?.object(forKey: "createdBy") as? NSDictionary
                    if(createdBy != nil){
                        let uid = createdBy?.object(forKey: "uid") as! String
                        if(uid == currentUser.uid){
                            if let publishStatus = dict?.object(forKey: "publishStatus") as? String {
                                if(publishStatus == "draft"){
                                    let submittedISO = dict?.object(forKey: "submittedISO") as! String
                    
                                    let dictCases = ["submittedOn":submittedISO,
                                                    "caseKey":snapshot.key,
                                                    "publishStatus":publishStatus
                                    ] as NSDictionary
                    
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
