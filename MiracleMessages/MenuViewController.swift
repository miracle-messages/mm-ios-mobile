//
//  MenuViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 1/13/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import MessageUI

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GuideViewController" {
            let vc = segue.destination as! GuideViewController
            vc.mode = .disconnected
        }
    }


    @IBAction func btnEmailTapped(_ sender: UIButton)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["win.raguini@gmail.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)

        return mailComposerVC
    }

    func showSendMailErrorAlert()
    {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func didTapResourcesBtn(_ sender: Any) {
        let viewController = self.createWebViewController(withUrl: "https://miraclemessages.org/")
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func didTapAboutBtn(_ sender: Any) {
        let viewController = self.createWebViewController(withUrl: "https://miraclemessages.org/about/")
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func didTapFaqBtn(_ sender: Any) {
        let viewController = self.createWebViewController(withUrl: "https://miraclemessages.org/faq/")
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func didTapLogoutBtn(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
    }

    func createWebViewController(withUrl: String) -> WebViewController {
        let webController: WebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webViewController") as! WebViewController
        webController.urlString = withUrl
        return webController
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
