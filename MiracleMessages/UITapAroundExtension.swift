//
//  UITapAroundExtension.swift
//  MiracleMessages
//
//  Created by Jason Shultz on 2/21/18.
//  Copyright © 2018 Win Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
