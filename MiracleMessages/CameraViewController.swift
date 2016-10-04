//
//  CameraViewController.swift
//  MiracleMessages
//
//  Created by Win Raguini on 10/1/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AWSS3
import CameraEngine
import MessageUI
import Photos

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var playbackView: UIView!

    @IBOutlet weak var previewView: UIView!

    var cameraSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?

    var player: AVPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!

    var isRecording = false

    let dataOutput = AVCaptureMovieFileOutput()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up capture session
        cameraSession = AVCaptureSession()
        cameraSession!.sessionPreset = AVCaptureSessionPresetHigh

        //Add inputs
        configureCamera()

        configurePreview()

        cameraSession?.startRunning()
    }

    func configurePreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        previewView.layer.addSublayer(previewLayer!)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill

        let rootLayer: CALayer = self.playbackView.layer
        rootLayer.masksToBounds = true

        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.bounds = self.playbackView.bounds
        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        rootLayer.insertSublayer(avPlayerLayer, at: 0)

        avPlayerLayer.backgroundColor = UIColor.blue.cgColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer!.frame = self.previewView.bounds
        let orientation = UIApplication.shared.statusBarOrientation

        switch orientation {
        case .portrait:
            previewLayer?.connection.videoOrientation = .portrait
            break
        case .landscapeRight:
            previewLayer?.connection.videoOrientation = .landscapeRight
            break
        case .landscapeLeft:
            previewLayer?.connection.videoOrientation = .landscapeRight
            break
        case .portraitUpsideDown:
            previewLayer?.connection.videoOrientation = .portrait
            break
        default: break
            previewLayer?.connection.videoOrientation = .portrait
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureCamera() -> Void {
        do {

            cameraSession?.beginConfiguration()

            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            let captureDeviceAudio = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)


            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let audioInput = try AVCaptureDeviceInput(device: captureDeviceAudio)

            if (cameraSession?.canAddInput(deviceInput) == true) {
                cameraSession?.addInput(deviceInput)
            }

            if (cameraSession?.canAddInput(audioInput) == true) {
                cameraSession?.addInput(audioInput)
            }


            if (cameraSession?.canAddOutput(dataOutput) == true) {
                cameraSession?.addOutput(dataOutput)
            }

            cameraSession?.commitConfiguration()

        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
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


    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {

        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
        }

        print("File size before compression: \(Double(data.length / 1048576)) mb")
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")
        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }

            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                self.uploadtoS3(url: compressedURL)

                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: compressedURL)
                }) { saved, error in
                    if saved {
                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }

                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                break
            case .failed:
                break
            case .cancelled:
                break
            }
        }
//        let item = AVPlayerItem(url: outputFileURL)
//        player.replaceCurrentItem(with: item)
//        if (player.currentItem != nil) {
//            print("Starting playback!")
//            player.play()
//        } else {
//            print("Will not start playback")
//        }
//        return
    }

    @IBAction func didPressTakePhoto(_ sender: AnyObject) {
        if isRecording {
            dataOutput.stopRecording()
            isRecording = false
        } else {
            let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self

            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentsURL.appendingPathComponent("temp.mov")

            dataOutput.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
        }
        
        
    }

    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "Error sending email.", message: "Could not send email.", preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)

    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setToRecipients(["nurdin@gmail.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)

        return mailComposerVC
    }

    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        isRecording = true

        return
    }

    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)

            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }

    func uploadtoS3(url: URL) -> Void {
        let transferManager = AWSS3TransferManager.default()
        let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()

        uploadRequest1.bucket = "mm-interview-vids"
        uploadRequest1.key =  "mingo.mov"
        uploadRequest1.acl = AWSS3ObjectCannedACL.publicRead
        uploadRequest1.body = url

        uploadRequest1.uploadProgress = {(bytesSent:Int64,
            totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in

            DispatchQueue.main.sync(execute: { () -> Void in
                print("\(totalBytesSent) and total:\(totalBytesExpectedToSend) => \((Float(totalBytesSent)/Float(totalBytesExpectedToSend))*100)")
                // you can have a loading stuff in here.
            })
        }

        let task = transferManager?.upload(uploadRequest1)
        task?.continue( { (task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Upload successful")
                self.sendEmail()
            }
            return nil
        })

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
         self.dismiss(animated: true, completion: nil)
    }


}
