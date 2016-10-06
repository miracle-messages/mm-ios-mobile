//
//  LoginSummaryViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/26/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class LoginSummaryViewController: UIViewController, UIPageViewControllerDelegate {

    @IBOutlet weak var helloLabel: UILabel!

    @IBOutlet weak var volunteerNameLabel: UILabel!
    @IBOutlet weak var volunteerEmailLabel: UILabel!
    @IBOutlet weak var volunteerPhoneLabel: UILabel!
    @IBOutlet weak var volunteerLocationLabel: UILabel!

    var pageViewController : UIPageViewController!


    override func viewDidLoad() {
        super.viewDidLoad()
        displayVolunteerInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectSwitchUserBtn(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "name")

        dismiss(animated: true, completion: nil)

    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }


    func displayVolunteerInfo() -> Void {
        let defaults = UserDefaults.standard
        volunteerNameLabel.text = defaults.string(forKey: "name")
        volunteerEmailLabel.text = defaults.string(forKey: "email")
        volunteerPhoneLabel.text = defaults.string(forKey: "phone")
        volunteerLocationLabel.text = defaults.string(forKey: "location")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
