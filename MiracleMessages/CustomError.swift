//
//  CustomError.swift
//  MiracleMessages
//
//  For crashlytics, unlike fatal crashes, which are grouped via stack trace analysis,
//  logged errors are grouped by the NSError domain and code.
//  This is an important distinction between fatal crashes and logged errors for which this class was created.
//
//  Created by Shobhit on 2017-07-02.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation


/// This enum contains error code for custom errors that we want to differentiate on crashlytics console.
struct CustomErrorCodes {
    static let LOGIN = 1001
    static let CAPTURE_IMAGE = 1005
    static let VIDEO_UPLOAD = 1010
    static let FIREBASE_ERROR = 1015
    static let GENERIC = 2001
}


/// This is a custom error object which we can log on console and on crashlytics.
/// We can include different map of user information along with each custome error code.
/// For now there is only a string.
///
/// - loginError: any error related to login or creating profile.
/// - caputureImageError: any error related to caputuring photo
/// - videoUploadError: any error related to capturing or uploading video.

enum CustomError : CustomNSError {
    case loginError (String)
    case caputureImageError (String)
    case videoUploadError(String)
    case firebaseSaveError(String)
    
    static var errorDomain : String {
        return "CustomError"
    }
    
    var errorCode: Int {
        switch self{
        case .loginError:
            return CustomErrorCodes.LOGIN
        case .caputureImageError:
            return CustomErrorCodes.CAPTURE_IMAGE
        case .videoUploadError:
            return CustomErrorCodes.VIDEO_UPLOAD
        case .firebaseSaveError:
            return CustomErrorCodes.FIREBASE_ERROR
        }
    }
    
    
    /// This is to send a mapping of user info. Right now it is a string.
    /// We can have this customized for each kind of error to return more than just a string.
    var errorUserInfo: [String : Any] {
        switch self {
        case .loginError (let error),
             .caputureImageError(let error),
             .videoUploadError(let error),
             .firebaseSaveError(let error):
            return ["error" : error]
        }
    }
}
