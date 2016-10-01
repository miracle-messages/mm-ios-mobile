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
            
//            self.presentViewController(alertController, animated: true) {
//                // ...
//            }
            present(alertController, animated: true, completion: {})

        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
//            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//            let documentsDirectory: AnyObject = paths[0]
//            let dataPath = documentsDirectory.URLBy
//            let token = "AIzaSyDR9y33OvZIu2XTW69nE1m0ra4ba_7Gjcs"
//            let headers = ["Authorization": "Bearer \(token)"]
//            let urlYoutube = "https://www.googleapis.com/upload/youtube/v3/videos?part=id&mine=true"
//            let urlForYoutube = try! URLRequest(url: urlYoutube, method: .post, headers: headers)

            

//            let path = Bundle.main.path(forResource: "video", ofType: "mp4")

//            Alamofire.upload(multipartFormData: { (multipartFormData) in
//                multipartFormData.append(videoData!, withName: "video", fileName: "video.mp4", mimeType: "application/octet-stream")
//                }, with: urlForYoutube,
//                encodingCompletion: { (result) in
//                    switch result {
//                    case .success(let upload, _, _):
//                        upload.responseJSON { response in
//                            debugPrint(response)
//                        }
//                    case .failure(let encodingError):
//                        print(encodingError)
//                    }
//            })

        }
        imagePicker.dismiss(animated: true, completion: {
            print("dismissed")
        })
    }

    func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        print("video saved")
    }


}

