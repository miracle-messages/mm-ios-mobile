//
//  BeginRecordingViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/28/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class BeginRecordingViewController: UIViewController, UINavigationControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

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

    
    @IBAction func didPressBeginRecordingBtn(_ sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            if UIImagePickerController.availableCaptureModes(for: UIImagePickerControllerCameraDevice.rear) != nil {
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self

                present(imagePicker, animated: true, completion: {})
            } else {
                let alertController = UIAlertController(title: "Rear camera doesn't exist", message: "Application can't access camera.", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    // ...
                }
                alertController.addAction(cancelAction)

                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // ...
                }
                alertController.addAction(OKAction)

                present(alertController, animated: true, completion: {})
            }
        } else {
            let alertController = UIAlertController(title: "Camera doesn't exist", message: "Application can't access camera.", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)

            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // ...
            }
            alertController.addAction(OKAction)
            
            present(alertController, animated: true, completion: {})

        }
    }

}

extension BeginRecordingViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, #selector(BeginRecordingViewController.video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
            var videoData: Data?
            do {
                videoData = try Data(contentsOf: pickedVideo as URL, options: .alwaysMapped)//NSData(contentsOf: pickedVideo as URL)
            } catch {
                print("Error")
            }

        }
        imagePicker.dismiss(animated: true, completion: {
            print("dismissed")
        })
    }

    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        print("video saved")
    }


}

