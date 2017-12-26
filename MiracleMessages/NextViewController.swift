//
//  NextViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 2/8/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapNextBtn(_ sender: Any) {
        let _ = Case.startNewCase()
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewController" {
            let webController = segue.destination as? WebViewController
            webController?.urlString = "\(appWebsite)/getinvolved/"
        }
    }
}
