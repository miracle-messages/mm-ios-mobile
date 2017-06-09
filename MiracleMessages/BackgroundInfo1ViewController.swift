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
    @IBOutlet weak var textViewContactInfo: UITextField!
    @IBOutlet weak var textViewOtherInfo: UITextField!
    @IBOutlet weak var textViewPartnerOrg: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldClientName.delegate = self
        textFieldClientDob.delegate = self
        textFieldClientCurrentLocation.delegate = self
        textFieldClientHometown.delegate = self
        textFieldClientYearsHomeless.delegate = self
        textViewContactInfo.delegate = self        

//        let yearsHomelessPlaceholder = NSAttributedString(string: self.textFieldClientYearsHomeless.placeholder!, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17)])
//        self.textFieldClientYearsHomeless.attributedPlaceholder = yearsHomelessPlaceholder
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundInfo = BackgroundInfo.init(defaults: UserDefaults.standard)
        displayInfo()
    }

    func displayInfo() -> Void {
        guard let clientInfo = self.backgroundInfo else {return}
        textFieldClientName.text = clientInfo.client_name
        textFieldClientDob.text = clientInfo.client_dob
        textFieldClientCurrentLocation.text = clientInfo.client_current_city
        textFieldClientHometown.text = clientInfo.client_hometown
        textFieldClientYearsHomeless.text = clientInfo.client_years_homeless
        textViewContactInfo.text = clientInfo.client_contact_info
        textViewOtherInfo.text = clientInfo.client_other_info
    }

    func updateBackgroundInfo() -> BackgroundInfo? {
        self.backgroundInfo?.client_name = self.textFieldClientName.text
        self.backgroundInfo?.client_dob = self.textFieldClientDob.text
        self.backgroundInfo?.client_current_city = self.textFieldClientCurrentLocation.text
        self.backgroundInfo?.client_hometown = self.textFieldClientHometown.text
        self.backgroundInfo?.client_contact_info = self.textViewContactInfo.text
        self.backgroundInfo?.client_years_homeless = self.textFieldClientYearsHomeless.text
        self.backgroundInfo?.client_other_info = self.textViewOtherInfo.text
        self.backgroundInfo?.save()        
        return self.backgroundInfo
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        let _ = self.updateBackgroundInfo()
        // Pass the selected object to the new view controller.
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard !(self.textFieldClientName.text?.isEmpty)! else {
            let alert = UIAlertController(title: "Cannot continue.", message: "You will need to enter the client's name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        switch mode {
        case .view:
            return true
        default:
            if let clientInfo = self.updateBackgroundInfo() {
                self.delegate?.clientInfo = clientInfo
            }
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishUpdating()
            })
            return false
        }
    }

}
