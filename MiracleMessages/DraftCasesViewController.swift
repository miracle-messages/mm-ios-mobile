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

class DraftCasesViewController: UIViewController {

    @IBOutlet weak var tblCases: UITableView!
    var ref: DatabaseReference!
    var arrCases : NSMutableArray = NSMutableArray()
    var currentCase: Case = Case.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblCases.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRecordNewVideoClicked(_ sender: Any) {
       let guideVC = self.storyboard?.instantiateViewController(withIdentifier: "GuideViewController") as! GuideViewController
       self.navigationController?.pushViewController(guideVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DraftCasesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1   //  One for Sender, one for Recipients
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
        let submittedDate = df.string(from: date!)
        print("submittedDate: \(submittedDate)")
        return submittedDate
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict : NSDictionary = self.arrCases[indexPath.row] as! NSDictionary
        let caseKey = dict.object(forKey: "caseKey") as! NSString
        
        let confirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        self.currentCase.key = caseKey as String
        self.navigationController?.pushViewController(confirmVC, animated: true)
        
//        let draftPhotoVideoVC = self.storyboard?.instantiateViewController(withIdentifier: "DraftPhotoVideoViewController") as! DraftPhotoVideoViewController
//        draftPhotoVideoVC.caseID = caseKey as String!
//        self.navigationController?.pushViewController(draftPhotoVideoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101
    }
}
