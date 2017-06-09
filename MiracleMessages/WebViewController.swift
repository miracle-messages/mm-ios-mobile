//
//  WebViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 2/8/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var closeBtn: UIButton!

    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        if let webUrl = urlString, let url = URL(string: webUrl) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
        if let _ = navigationController {
            let close = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapBackBtn))
            navigationItem.leftBarButtonItem = close
        }
    }
    
    func didTapBackBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCloseBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
