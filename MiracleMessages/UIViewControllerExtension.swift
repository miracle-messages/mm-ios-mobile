//
//  UIViewControllerExtension.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 7/15/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWithTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() { view.endEditing(true) }
}
