//
//  AppDelegate.swift
//  MiracleMessages
//
//  Created by Win Raguini on 9/25/16.
//  Copyright © 2016 Win Inc. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3
import HockeySDK
import Firebase
import GoogleSignIn
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    let cognitoIdentityPoolId = "us-west-2:22d14ee0-7c0a-4ddc-b74d-24b09e62a5d6"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.register(defaults: ["UserAgent": "com.miraclemessages.app"])
        UIApplication.shared.statusBarView?.backgroundColor = .white

        let backIcon = UIImage(named: "backBtn")
        UINavigationBar.appearance().backIndicatorImage = backIcon
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIcon
        UINavigationBar.appearance().tintColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().backgroundColor = UIColor.white

        // Override point for customization after application launch.
        FIRApp.configure()

        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: AWSRegionType.usWest2, identityPoolId: cognitoIdentityPoolId)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.usWest2, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration

        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black

        BITHockeyManager.shared().configure(withIdentifier: "f181897382a64cafaba5f2d86a98cf4a")
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()

        // Init Crashlytics. This should be the last line after other loggers have initialized.
        Fabric.with([Crashlytics.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            if (rootViewController.responds(to: Selector(("canRotate")))) {
                // Unlock landscape right
                return [.landscapeRight, .landscapeLeft] ;
            }
        }

        // Only allow portrait (standard behaviour)
        return .portrait;
    }

    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if (rootViewController == nil) { return nil }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
        if (components.path == "get_started") {
            self.presentDetailViewController()
            return true
        }

        let webpageUrl = URL(string: "https://miraclemessages.org")!
        application.openURL(webpageUrl)
        
        return false
    }
}

extension AppDelegate {
    
    func presentDetailViewController() {
        let currentVC = getCurrentViewController()
        currentVC?.dismiss(animated: false, completion: {[unowned self] in
            let vc = self.getCurrentViewController()!
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let startController = storyBoard.instantiateViewController(withIdentifier: "startViewController")
            let nav = UINavigationController(rootViewController: startController)
            nav.modalPresentationStyle = .overCurrentContext
            vc.present(nav, animated: false, completion: nil)
        })
    }
    
    // Returns the most recently presented UIViewController (visible)
    func getCurrentViewController() -> UIViewController? {
        
        // If the root view is a navigation controller, we can just return the visible ViewController
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    // Returns the navigation controller if it exists
    func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            Logger.forceLog(CustomError.loginError(error.localizedDescription))
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                // ...
                Logger.forceLog(CustomError.loginError(error.localizedDescription))
                return
            }
            guard let user = user else {return}

            let defaults = UserDefaults.standard
            defaults.set(user.providerData[0].displayName, forKey: "name")
            defaults.set(user.providerData[0].email, forKey: "email")
            defaults.synchronize()
            
            // After successful login, initialize user for crashlytics to better identify the user in crashes.
            Logger.initCrashlyticsUser(user.uid, user.email, user.displayName)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // Since there is a limit of 8 force logged NSError per user session, we should use them wisely.
        // If user manually cancels the signin, we need not report it to crashlyitcs.
        // https://docs.fabric.io/apple/crashlytics/logged-errors.html
        if (error.code != GIDSignInErrorCode.canceled.rawValue) {
            Logger.forceLog(error)
        } else {
            Logger.log(level: Level.error, "User cancelled the sign in request. Code: \(error.code), error: \(error.description)")
        }
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

