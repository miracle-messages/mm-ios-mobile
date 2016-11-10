//
//  BackgroundInfoView2Controller.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/9/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class BackgroundInfoView2Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem?.backBarButtonItem?.title = ""

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !UIImagePickerController.isCameraDeviceAvailable(.rear) {
            let alert = UIAlertController(title: "Cannot access camera.", message: "You will need a rear-view camera to record an interview", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }

}
