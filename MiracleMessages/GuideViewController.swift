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

}
