//
//  Config.swift
//  MiracleMessages
//
//  Created by Winfred Raguini on 10/14/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation

struct Config {
    static let baseUrl = Bundle.main.infoDictionary?["BASE_URL"] as! String
    static let registerUrl = Bundle.main.infoDictionary?["REGISTER_URL"] as! String
    static let firebaseConfigFileName = Bundle.main.infoDictionary?["FIREBASE"] as! String
}

// Firebase Root
let cases = "cases"
let casesPrivate = "casesPrivate"
let users = "users"
let lovedOnes = "lovedOnes"
let caseVideos = "caseVideos"
let caseSignatures = "caseSignatures"

// URL
let awsHost = "https://s3-us-west-2.amazonaws.com"
let bucketName = "mm-interview-vids"
let appWebsite = "https://miraclemessages.org"
let cognitoIdentityPoolId = "us-west-2:22d14ee0-7c0a-4ddc-b74d-24b09e62a5d6"
let BITHockeyID = "f181897382a64cafaba5f2d86a98cf4a"

// Identifier
let IdentifireStartView = "startViewController"
let IdentifireConfirmView = "ConfirmViewController"
let IdentifireReviewView = "ReviewViewController"
let IdentifireDraftCasesView = "DraftCasesViewController"
let IdentifireGuideView = "GuideViewController"
let IdentifireMenuView = "MenuViewController"
let IdentifireWebView = "webViewController"
let IdentifireBackgroundInfo1View = "BackgroundInfo1ViewController"
let IdentifireBackgroundInfo2View = "BackgroundInfo2ViewController"
let IdentifireCameraView = "cameraViewController"
let IdentifireNextView = "NextViewController"
let IdentifirePermissionView = "PermissionViewController"
let IdentifireSignUpView = "SignUpViewController"

// Keyword
let AppName = "Miracle Messages"
let Propic = UserDefaults.standard



