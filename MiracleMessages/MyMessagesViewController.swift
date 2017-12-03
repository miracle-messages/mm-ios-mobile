//
//  MyMessagesViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 7/31/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit
import Firebase

class MyMessagesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    var cases = [CaseSummary]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        ref = Database.database().reference()
        updateCases()
    }

    func updateCases()  {
        let userID = Auth.auth().currentUser?.uid // 6zZOhaFWHqOBb1X4FlHQtKgdUGn2
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {return}
            print("Cases \(value)")
            guard let cases = value.object(forKey: "cases") as? [String: Any] else {return}
            print("Cases are \(cases)")
            guard let _self = self else {return}
            for (key, element) in cases {
                let dict = element as! [String:Any]
                print("element: \(dict)")
                let photoUrl = dict["photo"] as! String
                let firstName = dict["firstName"] as! String
                let lastName = dict["lastName"] as! String
                let caseSummary = CaseSummary(name: "\(firstName) \(lastName)", imageUrl: photoUrl, key: key)
                _self.cases.append(caseSummary)
                _self.tableView.reloadData()
            }

        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension MyMessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let caseSummary = cases[indexPath.row]
        let webController: WebViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webViewController") as! WebViewController
        webController.urlString = caseSummary.caseURL
        navigationController?.present(webController, animated: true, completion: nil)
    }
}

extension MyMessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CaseTableViewCell", for: indexPath) as? CaseTableViewCell else { return UITableViewCell() }
        let caseSummary = cases[indexPath.row]
        cell.configure(with: caseSummary)

        return cell
    }
}
