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
    var mode: GuideMode = .connected
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageCtrl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        pageCtrl.pageIndicatorTintColor = UIColor.lightGray
        pageCtrl.currentPageIndicatorTintColor = UIColor.black
        switch mode {
        case .connected:
            nextBtn.isHidden = false
        default:
            nextBtn.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
