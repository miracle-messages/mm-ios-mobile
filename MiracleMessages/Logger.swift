//
//  Logger.swift
//  MiracleMessages
//
//  This is custom logger which logs to console when in debug mode and to crashlytics in release mode.
//  We can use helper methods here to log force log non fatal excetions/errors to Crashlytics.
//
//  Created by Shobhit on 2017-07-01.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import Foundation
import Crashlytics

enum Level {
    case debug
    case error
    case info
    case verbose
    case warn
    
    func toString() -> String {
        switch self {
        case .debug:
            return "DEBUG"
        case .error:
            return "ERROR"
        case .info:
            return "INFO"
        case .verbose:
            return "VERBOSE"
        case .warn:
            return "WARNING"
        }
    }
}

struct Logger {
    
    /// This logs only on console when in debug and only on crashlytics when in release build.
    ///
    /// - Parameters:
    ///   - level: log level (info by default)
    ///   - log: log message
    static func log(level: Level = .info,
                    _ message: String,
                    fileName: String = #file,
                    line: Int = #line,
                    methodName: String = #function) {
        
        #if DEBUG
            print("\(Date()) | " +
                "\(level.toString()) | " +
                "\((fileName as NSString).lastPathComponent)(\(line))-\(methodName) | " +
                "\(encodeLog(message))")
        #else
            // Only logs on crashlytics and not on console to improve performance. Use CLSNSLogv if you want both.
            CLSLogv("\(level.toString()) |" +
                "\((fileName as NSString).lastPathComponent)(\(line))-\(methodName) | " +
                "\(encodeLog(message))", getVaList([]))
            print("\(Date()) | " +
                "\(level.toString()) | " +
                "\((fileName as NSString).lastPathComponent)(\(line))-\(methodName) | " +
                "\(encodeLog(message))")
        #endif
    }
    
    
    /// This will force record a non fatal error on crashlytics in release mode.
    ///
    /// - Parameters:
    ///   - level: log level (error by default)
    ///   - error: NSError
    static func forceLog(level: Level = .error,
                         _ error: NSError,
                         fileName: String = #file,
                         line: Int = #line,
                         methodName: String = #function) {
        
        #if DEBUG
            print("\(Date()) | " +
                "\(level.toString()) | " +
                "\((fileName as NSString).lastPathComponent)(\(line))-\(methodName) | " +
                "\(error)")
        #else
            Crashlytics.sharedInstance().recordError(error)
            print("\(Date()) | " +
                "\(level.toString()) | " +
                "\((fileName as NSString).lastPathComponent)(\(line))-\(methodName) | " +
                "\(error)")
        #endif
    }
    
    
    /// This will force record custom errors on Crashlytics in release mode. In debug mode just prints them.
    ///
    /// - Parameters:
    ///   - level: log level (error by default)
    ///   - error: @CustomError object
    static func forceLog(level: Level = .error,
                         _ error: CustomError,
                         fileName: String = #file,
                         line: Int = #line,
                         methodName: String = #function) {
        
        #if DEBUG
            print("\(Date()) | " +
                "\(level.toString()) | " +
                "\((fileName as NSString).lastPathComponent)(\(line))-\(methodName) | " +
                "\(error.errorUserInfo)")
        #else
            Crashlytics.sharedInstance().recordError(error)
            print("\(Date()) | " +
                "\(level.toString()) | " +
                "\((fileName as NSString).lastPathComponent)(\(line))-\(methodName) | " +
                "\(error.errorUserInfo)")
        #endif
    }
    
    
    /// Helper method to sanitize the log message.
    ///
    /// - Parameter str: string to sanitize
    /// - Returns: return sanitized string
    static func encodeLog(_ str: String) -> String {
        return str.replacingOccurrences(of: "%", with: "%%")
    }
    
    
    /// Initilizes user details for crashlytics to display with crash logs.
    ///
    /// - Parameters:
    ///   - userId: userId
    ///   - email: email
    ///   - name: Name
    static func initCrashlyticsUser (_ userId: String?, _ email: String?, _ name: String?) {
        if userId != nil {
            Crashlytics.sharedInstance().setUserIdentifier(userId)
        }
        
        if (email != nil) {
            Crashlytics.sharedInstance().setUserEmail(email)
        }
        
        if (name != nil) {
            Crashlytics.sharedInstance().setUserName(name)
        }
    }
    
}
