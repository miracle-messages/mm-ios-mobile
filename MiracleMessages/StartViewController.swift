//
//  StartViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/10/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class StartViewController: ProfileNavigationViewController {

    @IBOutlet weak var helloLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        resetCaseID()
        displayVolunteerInfo()
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
