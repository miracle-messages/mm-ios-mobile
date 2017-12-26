//
//  GuideViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/11/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

enum GuideMode {
    case connected
    case disconnected
}

class GuideViewController: ProfileNavigationViewController {
   
    @IBOutlet weak var nextBtn: UIButton!
    var mode: GuideMode = .connected

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BackgroundInfo1ViewController {
            Case.current = Case()   // BackgroundInfoViewController will pull the current case
        }
    }

}
