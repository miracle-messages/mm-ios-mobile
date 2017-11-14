//
//  BackgroundInfoOptionalViewController.swift
//  MiracleMessages
//
//  Created by Shobhit on 2017-11-06.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class BackgroundInfoOptionalViewController: UIViewController {

    @IBOutlet weak var mLooseTouchReasonText: UITextView!
    
    @IBOutlet weak var mHomelessReason: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mLooseTouchReasonText.placeholder = "Answer"
        mHomelessReason.placeholder = "Answer"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // let _ = self.updateBackgroundInfo()
        // Pass the selected object to the new view controller.
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
