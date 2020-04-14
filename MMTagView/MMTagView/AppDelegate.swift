//
//  AppDelegate.swift
//  MMTagView
//
//  Created by 马扬 on 2020/4/14.
//  Copyright © 2020 mayang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = ViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        return true
    }


}

