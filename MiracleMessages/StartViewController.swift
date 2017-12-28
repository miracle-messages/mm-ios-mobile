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
        ref.child("/\(cases)/").observe(.childAdded, with: { (snapshot) in
            self.arrKey.add(snapshot.key)
            self.RemoveActivityIndicator()
        })
    }
    
    @IBAction func btnGetStartedClicked(_ sender: Any) {
        self.ShowActivityIndicator()
        
        let draftCase = DispatchGroup()
        guard let currentUser = Auth.auth().currentUser else { return }

        for key in self.arrKey {
            draftCase.enter()
            self.ref?.child("/\(cases)/").child(key as! String).observeSingleEvent(of: .value, with:
                { (snapshot) in
                    let dict = snapshot.value as? NSDictionary
                    let createdBy = dict?.object(forKey: "createdBy") as? NSDictionary
                    let publishStatus = dict?.object(forKey: "publishStatus") as? String
                    if(createdBy != nil){
                       let uid = createdBy?.object(forKey: "uid") as! String
                       if(uid == currentUser.uid && publishStatus == "draft"){
                           let submittedISO = dict?.object(forKey: "created") as? String
                           let dictCases: [String: Any] = [
                              "submittedOn":submittedISO ?? "",
                              "publishStatus":publishStatus ?? "",
                              "caseKey": snapshot.key,
                           ]
                           self.arrCases.add(dictCases)
                        }
                    }
                    draftCase.leave()
                })
            }
      
        draftCase.notify(queue:DispatchQueue.main) {
            self.RemoveActivityIndicator()
            if(self.arrCases.count > 0){
                let draftCasesVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireDraftCasesView) as! DraftCasesViewController
                draftCasesVC.arrCases = NSMutableArray()
                draftCasesVC.arrCases = self.arrCases
                self.navigationController?.pushViewController(draftCasesVC, animated: true)
            } else{
                let guideVC = self.storyboard?.instantiateViewController(withIdentifier: IdentifireGuideView) as! GuideViewController
                self.navigationController?.pushViewController(guideVC, animated: true)
            }
        }
    }
    
    func ShowActivityIndicator(){
        let size = CGSize(width: 50, height:50)
        startAnimating(size, message: nil, type: NVActivityIndicatorType(rawValue: 6)!)
    }
    
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
