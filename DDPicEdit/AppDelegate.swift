//
//  AppDelegate.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/3/16.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isSupportLandScapeOrientation = false
    static var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let windows = UIWindow.init(frame: UIScreen.main.bounds)
        let homeViewController: HomeViewController
        if #available(iOS 13.0, *) {
            homeViewController = HomeViewController(style: .insetGrouped)
        } else {
            homeViewController = HomeViewController(style: .grouped)
        }
        let navi = UINavigationController(rootViewController: homeViewController)
        windows.rootViewController = navi
        windows.makeKeyAndVisible()
        self.window = windows
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.isSupportLandScapeOrientation ? .allButUpsideDown : .portrait
    }
}

