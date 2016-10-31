//
//  IntroViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/28/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIPageViewControllerDelegate {

    var pageViewController : UIPageViewController!

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController!.navigationBar.topItem!.title = ""

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    func didSelectSkipBtn() -> Void {
//        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentSize.width - self.scrollView.frame.width, y: 0), animated: true)
//        updateSlideText(currentPage: 5)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier != "thankyouSegue" {
                let cameraController = segue.destination as! CameraViewController
                cameraController.delegate = self
        }
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

    func didFinishRecording() -> Void {
        performSegue(withIdentifier: "thankyouSegue", sender: self)
    }


}


