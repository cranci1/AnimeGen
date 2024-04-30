//
//  AppDelegate.swift
//  AnimeGen
//
//  Created by cranci on 11/02/24.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UserDefaults.standard.register(defaults: ["enableAnimations": true])
        UserDefaults.standard.register(defaults: ["enableTags": true])
        UserDefaults.standard.register(defaults: ["enableGestures": true])
        UserDefaults.standard.register(defaults: ["enableKyokobanner": true])
        UserDefaults.standard.register(defaults: ["enableImageStartup": true])
        UserDefaults.standard.register(defaults: ["enableHistoryOvertime": true])
        
        
        // Tutorial View Prompt
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            
            let tutorialView = TutorialView()
                .edgesIgnoringSafeArea(.all)
            let hostingController = UIHostingController(rootView: tutorialView)
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = hostingController
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
