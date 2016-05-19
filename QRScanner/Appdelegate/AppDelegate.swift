//
//  AppDelegate.swift
//  QRScanner
//
//  Created by Abdelrahman Ahmed on 5/18/16.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let vc = ScannerViewController()
        window?.rootViewController = vc
        
        self.window?.makeKeyAndVisible()

        return true
    }

}

