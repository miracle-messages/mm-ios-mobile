//
//  BackgroundInfoView2Controller.swift
//  MiracleMessages
//
//  Created by Win Raguini on 11/9/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

protocol CameraViewControllerDelegate: class {
    func didFinishRecording(sender: CameraViewController)
}

class BackgroundInfoView2Controller: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var textViewLabel: UILabel!

    @IBOutlet weak var textView: UITextView!

    var keyboardIsVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        self.navigationController!.navigationBar.topItem?.backBarButtonItem?.title = ""

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShowNotification(notification: NSNotification) {

        // get the size of the keyboard
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, !self.keyboardIsVisible {
            let contentInsets = UIEdgeInsets(top: 64.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            self.keyboardIsVisible = true
        }


    }

    func keyboardWillHideNotification(notification: NSNotification) {
        // get the size of the keyboard
        guard self.keyboardIsVisible else {
            return
        }
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.keyboardIsVisible = false
    }

    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cameraController = segue.destination as? CameraViewController
        cameraController?.delegate = self
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !UIImagePickerController.isCameraDeviceAvailable(.rear) {
            let alert = UIAlertController(title: "Cannot access camera.", message: "You will need a rear-view camera to record an interview", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }

}

extension BackgroundInfoView2Controller: CameraViewControllerDelegate {
    func didFinishRecording(sender: CameraViewController) -> Void {
        let allViewController: [UIViewController] = self.navigationController!.viewControllers

        for aviewcontroller : UIViewController in allViewController
        {
            if aviewcontroller is LoginSummaryViewController
            {
                self.navigationController?.popToViewController(aviewcontroller, animated: true)
            }
        }
    }
}


extension BackgroundInfoView2Controller: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            self.textViewLabel.isHidden = true
        } else {
            self.textViewLabel.isHidden = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            self.textViewLabel.isHidden = true
        } else {
            self.textViewLabel.isHidden = false
        }
    }
    
}
