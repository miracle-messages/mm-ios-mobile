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
import MessageUI
import Photos


class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate, MFMailComposeViewControllerDelegate {

    var startTime = TimeInterval()
    var timer = Timer()
    var videoFileName: String?

    var delegate: IntroViewController!

    //Landscape constraints
    @IBOutlet weak var recordBtnCntrVrtConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordBtnRtConstraint: NSLayoutConstraint!
    @IBOutlet weak var thankYouView: UIView!
    //Portrait constraints
    @IBOutlet weak var recordBtnBtmConstraint: NSLayoutConstraint!
    @IBOutlet weak var recordBtnCenterConstraint: NSLayoutConstraint!

    @IBOutlet weak var percentageLbl: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var questionScrollView: UIScrollView!
//    @IBOutlet weak var playbackView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var previewView: UIView!

    var cameraSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?

    var player: AVPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!

    var isRecording = false

    let dataOutput = AVCaptureMovieFileOutput()

    let bucketName: String = "mm-interview-vids"

    let awsHost: String = "https://s3-us-west-2.amazonaws.com"

    let questionsArray: [String] = [
        "First, about you. Please clearly say and spell your full name.",
        "What is your date of birth?",
        "Where do you currently live? (city, state, country)",
        "Where is your hometown?",
        "How many years have you been homeless?",
        "What is the best way for us to reach you again? And just so you know, it is not our intention to share this information publicly, only among our volunteers.",
        "Now, about your loved one(s). Please clearly say and spell their full name.",
        "What is their relationship to you?",
        "What is their date of birth or approximate age?",
        "What is their current or last known location?",
        "How many years has it been since you last saw them?",
        "Any other information you think might be helpful? (names of other relatives, previous addresses, reason for being disconnected...)"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.progressBarView.progress = 0
        self.hideProgressView()

        //Set up capture session
        cameraSession = AVCaptureSession()
        cameraSession!.sessionPreset = AVCaptureSessionPresetMedium

        //Add inputs
        configureCamera()

        configurePreview()

        cameraSession?.startRunning()

        self.questionScrollView.frame = CGRect(x: 0, y: self.previewView.frame.size.height, width: self.view.frame.size.width, height: 125)
        let scrollViewHeight: CGFloat = self.questionScrollView.frame.height
        let scrollViewWidth: CGFloat = self.questionScrollView.frame.width

        let scrollViewBgView = UIView(frame: CGRect(x: 0, y: 0, width: self.questionScrollView.frame.width, height: self.questionScrollView.frame.height))
        scrollViewBgView.backgroundColor = UIColor.black
        scrollViewBgView.alpha = 0.4

        self.questionScrollView.addSubview(scrollViewBgView)

        var questionWidth: CGFloat = 0
        for question in questionsArray {
            let questionLbl1 = UILabel(frame: CGRect(x: questionWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight - 8))
            questionLbl1.textAlignment = NSTextAlignment.center
            questionLbl1.numberOfLines = 0
            questionLbl1.font = UIFont.init(name: "System", size: 15)
            questionLbl1.textColor = UIColor.white
            questionLbl1.text = question
            questionLbl1.alpha = 1
            self.questionScrollView.addSubview(questionLbl1)
            questionWidth += scrollViewWidth
        }


        self.pageControl.backgroundColor = UIColor.clear

        self.questionScrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(questionsArray.count), height: scrollViewHeight)
        self.questionScrollView.delegate = self
        self.pageControl.currentPage = 0

        pageControl.alpha = 1
    }

    func configurePreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        previewView.layer.addSublayer(previewLayer!)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill


        self.previewView.bringSubview(toFront: self.recordBtn)
        self.previewView.bringSubview(toFront: self.timerLabel)
        self.previewView.bringSubview(toFront: self.closeBtn)

//        let rootLayer: CALayer = self.playbackView.layer
//        rootLayer.masksToBounds = true
//
//        avPlayerLayer = AVPlayerLayer(player: player)
//        avPlayerLayer.bounds = self.playbackView.bounds
//        avPlayerLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        rootLayer.insertSublayer(avPlayerLayer, at: 0)
//
//        avPlayerLayer.backgroundColor = UIColor.blue.cgColor
    }

    func reconfigureQuestionScrollView() -> Void {
        var questionWidth: CGFloat = 0
        var currentFrame = CGRect.zero
        var page: Int = 0
        for questionView in self.questionScrollView.subviews {
            if let questionLbl = questionView as? UILabel {
                questionLbl.frame = CGRect(x: questionWidth, y: 0, width: self.questionScrollView.frame.width, height: self.questionScrollView.frame.height)
                questionWidth += self.questionScrollView.frame.width
                if self.pageControl.currentPage == page {
                    currentFrame = questionLbl.frame
                }
                page += 1
            } else {
                let backgroundViewFrame = questionView.frame
                let newWidth = self.questionScrollView.frame.width * CGFloat(self.questionsArray.count)
                questionView.frame = CGRect(x: -200, y: 0, width: newWidth + 500, height: backgroundViewFrame.height)
            }
        }
        self.questionScrollView.contentSize = CGSize(width: self.questionScrollView.frame.width * CGFloat(self.questionsArray.count), height: self.questionScrollView.frame.height)
        self.questionScrollView.scrollRectToVisible(currentFrame, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        enableLandscapeConstraints()
        previewLayer!.frame = self.previewView.bounds

        reconfigureQuestionScrollView()

        let orientation = UIApplication.shared.statusBarOrientation
        let captureConnection = dataOutput.connection(withMediaType: AVMediaTypeVideo)
        switch orientation {
        case .portrait:
            previewLayer?.connection.videoOrientation = .portrait
            captureConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
            enablePortraitConstraints()
            break
        case .landscapeRight:
            previewLayer?.connection.videoOrientation = .landscapeRight
            captureConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            enableLandscapeConstraints()
            break
        case .landscapeLeft:
            previewLayer?.connection.videoOrientation = .landscapeLeft
            captureConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            enableLandscapeConstraints()
            break
        case .portraitUpsideDown:
            previewLayer?.connection.videoOrientation = .portrait
            captureConnection?.videoOrientation = AVCaptureVideoOrientation.portrait
            enablePortraitConstraints()
            break
        default: break
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

    }

    func enablePortraitConstraints() -> Void {
        //Landscape constraints
        self.recordBtnCntrVrtConstraint.isActive = false
        self.recordBtnRtConstraint.isActive = false

        //Portrait constraints
        self.recordBtnBtmConstraint.isActive = true
        self.recordBtnCenterConstraint.isActive = true
    }

    func enableLandscapeConstraints() -> Void {
        //Landscape constraints
        self.recordBtnCntrVrtConstraint.isActive = true
        self.recordBtnRtConstraint.isActive = true

        //Portrait constraints
        self.recordBtnBtmConstraint.isActive = false
        self.recordBtnCenterConstraint.isActive = false
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

    func updateTime() {

        let currentTime = NSDate.timeIntervalSinceReferenceDate

        //Find the difference between current time and start time.

        var elapsedTime: TimeInterval = currentTime - startTime

        //calculate the minutes in elapsed time.

        let minutes = UInt8(elapsedTime / 60.0)

        elapsedTime -= (TimeInterval(minutes) * 60)

        //calculate the seconds in elapsed time.

        let seconds = UInt8(elapsedTime)

        elapsedTime -= TimeInterval(seconds)

        //find out the fraction of milliseconds to be displayed.

        let fraction = UInt8(elapsedTime * 100)

        //add the leading zero for minutes, seconds and millseconds and store them as string constants

        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
    }

    func showProgressView() {
        self.view.bringSubview(toFront: self.progressView)
    }

    func hideProgressView() {
        self.percentageLbl.text = "0%"
        self.view.sendSubview(toBack: self.progressView)
    }

    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {

        guard let data = NSData(contentsOf: outputFileURL as URL) else {
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
        }) { saved, error in
            if saved {
                print("Saved successfully.")
            }
        }

        self.generateVideoFileName()

//        self.showProgressView()

//        self.uploadtoS3(url: outputFileURL)
        self.sendEmail()
        
        self.bgUploadToS3(url: outputFileURL)

        print("File size before compression: \(Double(data.length / 1048576)) mb")
        
//        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")
//        compressVideo(inputURL: outputFileURL as URL, outputURL: compressedURL) { (exportSession) in
//            guard let session = exportSession else {
//                return
//            }
//
//            switch session.status {
//            case .unknown:
//                break
//            case .waiting:
//                break
//            case .exporting:
//                break
//            case .completed:
//                guard let compressedData = NSData(contentsOf: compressedURL) else {
//                    return
//                }
//                self.uploadtoS3(url: compressedURL)
//
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: compressedURL)
//                }) { saved, error in
//                    if saved {
//                        print("Saved successfully.")
//                    }
//                }
//
//                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
//                break
//            case .failed:
//                break
//            case .cancelled:
//                break
//            }
//        }


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
            stopTimer()
            changeRecordBtn(recording: false)
            dataOutput.stopRecording()
            isRecording = false
        } else {
            startTimer()

            changeRecordBtn(recording: true)

            let recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self

            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentsURL.appendingPathComponent("temp.mov")

            dataOutput.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
        }
        
        
    }

    func changeRecordBtn(recording: Bool) -> Void {
        if recording {
            recordBtn.setBackgroundImage(UIImage(named:"stopRecordBtn"), for: .normal)
        } else {
            recordBtn.setBackgroundImage(UIImage(named:"recordBtn"), for: .normal)
        }
    }

    func startTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CameraViewController.updateTime), userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate
        }
    }

    func stopTimer() {
        timer.invalidate()
        timerLabel.text = "00:00:00"
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

    func displayVolunteerInfo() -> String {
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: "name"), let email = defaults.string(forKey: "email"), let phone = defaults.string(forKey: "phone"), let location = defaults.string(forKey: "location") {
            return "\(name)\n\(email)\n\(phone)\n\(location)"
        } else {
            return "There was an issue."
        }
    }

    func videoLink() -> String {
        return "\(self.awsHost)/\(self.bucketName)/\(self.videoFileName!)"
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        var components = DateComponents()
        components.setValue(1, for: .hour)
        let date: Date = Date()


        let videoAvailableDate = NSCalendar.current.date(byAdding: components, to: date)

        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .medium

        let dateString = formatter.string(from: videoAvailableDate!)

        mailComposerVC.setToRecipients(["mm@miraclemessages.org"])
        mailComposerVC.setSubject("[MM] Interview video")
        mailComposerVC.setMessageBody("\(self.displayVolunteerInfo())\n\nLink to video:\n\(self.videoLink())\n\n*If video is not available please wait until \(dateString) before downloading.\n\nPlease add any additional notes here:", isHTML: false)

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

    func generateVideoFileName() {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name")?.replacingOccurrences(of: " ", with: "-").lowercased()
        let date = Date()

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MM-dd-yyyy-HHmmss"
        let stringDate = dayTimePeriodFormatter.string(from: date)
        self.videoFileName = "\(name!)-\(stringDate).mov"
    }

    func bgUploadToS3(url: URL) -> Void {
        let transferUtility = AWSS3TransferUtility.default()


//        AWSS3TransferUtilityUploadExpression *expression = [AWSS3TransferUtilityUploadExpression new];
//        expression.progressBlock = ^(AWSS3TransferUtilityTask *task, NSProgress *progress) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Do something e.g. Update a progress bar.
//                });
//        };
//
//        AWSS3TransferUtilityUploadCompletionHandlerBlock completionHandler = ^(AWSS3TransferUtilityUploadTask *task, NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Do something e.g. Alert a user for transfer completion.
//                // On failed uploads, `error` contains the error object.
//                });
//        };
        let transferExpression = AWSS3TransferUtilityUploadExpression()

        transferExpression.progressBlock = { (task, progress) in
            DispatchQueue.main.sync(execute: { () -> Void in
                print("Progress \(progress.fractionCompleted)")
//                let percentage: Float = Float(totalBytesSent)/Float(totalBytesExpectedToSend)
//                self.progressBarView.progress = percentage
//
//                let percentFormatter = NumberFormatter()
//                percentFormatter.numberStyle = .percent
//
//                let percentageNumber = NSNumber(value: percentage)
//
//                self.percentageLbl.text = percentFormatter.string(from:  percentageNumber)
//                print("\(totalBytesSent) and total:\(totalBytesExpectedToSend) => \(percentage * 100)")
//                // you can have a loading stuff in here.
                })
        }

        var uploadCompletionHandlerBlock: AWSS3TransferUtilityUploadCompletionHandlerBlock?

        uploadCompletionHandlerBlock = { (task, error) in
            DispatchQueue.main.sync(execute: { () -> Void in
                if error != nil {
                    print("Upload successful")
                } else {
                    print("Error here: \(error.debugDescription)")
                }
            })
        }

        let uploadExpression = AWSS3TransferUtilityUploadExpression()

        uploadExpression.setValue("public-read", forRequestHeader: "x-amz-acl")

        if let newVideoFileName = self.videoFileName {
            transferUtility.uploadFile(url, bucket: self.bucketName, key: newVideoFileName, contentType: "application/octet-stream", expression: uploadExpression, completionHander: uploadCompletionHandlerBlock).continue( { (task) -> AnyObject! in
                if task.error != nil {
                    print("Error: \(task.error)")
                } else {
                    print("Upload successful")
                    DispatchQueue.main.async(execute: {[unowned self] in
                          print("Uploading file.")
//                        self.sendEmail()
//                        self.hideProgressView()
                        })
                }
                return nil
            })

        }


    }

    func uploadtoS3(url: URL) -> Void {
        let transferManager = AWSS3TransferManager.default()
        let uploadRequest1 : AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()

        if let newVideoFileName = self.videoFileName {
            uploadRequest1.bucket = self.bucketName
            uploadRequest1.key =  newVideoFileName
            uploadRequest1.acl = AWSS3ObjectCannedACL.publicRead
            uploadRequest1.body = url

            uploadRequest1.uploadProgress = {(bytesSent:Int64,
                totalBytesSent:Int64, totalBytesExpectedToSend:Int64) in

                DispatchQueue.main.sync(execute: {[unowned self] () -> Void in
                    let percentage: Float = Float(totalBytesSent)/Float(totalBytesExpectedToSend)
                    self.progressBarView.progress = percentage

                    let percentFormatter = NumberFormatter()
                    percentFormatter.numberStyle = .percent

                    let percentageNumber = NSNumber(value: percentage)

                    self.percentageLbl.text = percentFormatter.string(from:  percentageNumber)
                    print("\(totalBytesSent) and total:\(totalBytesExpectedToSend) => \(percentage * 100)")
                    // you can have a loading stuff in here.
                })
            }

            let task = transferManager?.upload(uploadRequest1)
            task?.continue( { (task) -> AnyObject! in
                if task.error != nil {
                    print("Error: \(task.error)")
                } else {
                    print("Upload successful")
                    DispatchQueue.main.async(execute: {[unowned self] in
                        self.sendEmail()
                        self.hideProgressView()
                    })
                }
                return nil
            })
        }

    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        self.dismiss(animated: true, completion: {[unowned self] in
            switch result {
            case MFMailComposeResult.sent:
                self.view.bringSubview(toFront: self.thankYouView)
                break
            default:
                break
            }
        })

    }

    @IBAction func didPressCloseBtn(_ sender: AnyObject) {
        if isRecording {
            stopTimer()
            changeRecordBtn(recording: false)
            dataOutput.stopRecording()
            isRecording = false
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didPressDoneBtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
    }
}
