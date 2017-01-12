//
//  ProfileNavigationViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/10/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class ProfileNavigationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.setImage(UIImage.init(named: "backBtn"), for: .normal)
//        let navBackBtn = UIBarButtonItem(customView: backBtn)
//        self.navigationItem.backBarButtonItem = navBackBtn

        ////
//
//        let backIndicatorImage = backBtn.image
//        navigationItem.backIndicatorTransitionMaskImage = backBtn.image

        self.navigationController?.navigationBar.transparentNavigationBar()

        let profileBtn = UIButton(type: UIButtonType.custom)

        profileBtn.setImage(UIImage.init(named: "homeBtn"), for: .normal)
        profileBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileBtn.addTarget(self, action: #selector(didPressProfileBtn), for: UIControlEvents.touchUpInside)


        let profileBarBtnItem = UIBarButtonItem(customView: profileBtn)
        self.navigationItem.rightBarButtonItem = profileBarBtnItem

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didPressProfileBtn() -> Void {
        print("Profile")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem

//        let backBtn = UIButton(type: UIButtonType.custom)
//
//        backBtn.setImage(UIImage.init(named: "backBtn"), for: .normal)

//        profileBtn.addTarget(self, action: #selector(didPressProfileBtn), for: UIControlEvents.touchUpInside)


//        let navBackBtn = UIBarButtonItem(customView: backBtn)
//        self.navigationItem.rightBarButtonItem = navBackBtn

//        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
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
