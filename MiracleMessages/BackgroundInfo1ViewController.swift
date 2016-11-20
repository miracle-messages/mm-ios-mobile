//
//  BackgroundInfoViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/7/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class BackgroundInfo1ViewController: BackgroundInfoViewController {

    @IBOutlet weak var textFieldClientName: UITextField!
    @IBOutlet weak var textFieldClientDob: UITextField!
    @IBOutlet weak var textFieldClientCurrentLocation: UITextField!
    @IBOutlet weak var textFieldClientHometown: UITextField!
    @IBOutlet weak var textFieldClientYearsHomeless: UITextField!
    @IBOutlet weak var textViewContactInfo: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let yearsHomelessPlaceholder = NSAttributedString(string: self.textFieldClientYearsHomeless.placeholder!, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17)])
        self.textFieldClientYearsHomeless.attributedPlaceholder = yearsHomelessPlaceholder
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateBackgroundInfo() -> BackgroundInfo? {
        self.backgroundInfo = BackgroundInfo(client_name: self.textFieldClientName.text!)
        self.backgroundInfo?.client_dob = self.textFieldClientDob.text
        self.backgroundInfo?.client_current_city = self.textFieldClientCurrentLocation.text
        self.backgroundInfo?.client_hometown = self.textFieldClientHometown.text
        self.backgroundInfo?.client_contact_info = self.textViewContactInfo.text
        self.backgroundInfo?.client_years_homeless = self.textFieldClientYearsHomeless.text
        return self.backgroundInfo
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let nextController = segue.destination as! BackgroundInfo2ViewController
        nextController.backgroundInfo = self.updateBackgroundInfo()

        // Pass the selected object to the new view controller.
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard !(self.textFieldClientName.text?.isEmpty)! else {
            let alert = UIAlertController(title: "Cannot continue.", message: "You will need to enter the client's name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

}
