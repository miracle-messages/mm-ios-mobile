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
    }

    func didPressProfileBtn() -> Void {
        let menuController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        navigationController?.pushViewController(menuController, animated: true)

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
}

extension UINavigationController {

}
