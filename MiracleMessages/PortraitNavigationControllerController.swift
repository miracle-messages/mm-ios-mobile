//
//  PortraitNavigationControllerController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 10/6/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class PortraitNavigationControllerController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
