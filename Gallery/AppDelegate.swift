//
//  AppDelegate.swift
//  Gallery
//
//  Created by Dumbo on 13/04/2020.
//  Copyright © 2020 Sronglong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // preload some sample file to document
        let manger = BundlFileManager()
        let document = DocumentFileManager()
        
        try? manger.allFiles(filter: FileFilter.init(condition: .image)).forEach{
            guard let document = document.documentsUrl else {return}
            let desUrl = document.appendingPathComponent($0.path.lastPathComponent)
            if $0.fileName.contains("AppIcon") {return}
            if FileManager.default.fileExists(atPath: desUrl.path) {
                print("FILE AVAILABLE")
            }else{
                do {
                  try FileManager.default.copyItem(at: $0.path, to: desUrl)
                    print("copied")
                } catch let nserror as NSError {
                  fatalError("Error: \(nserror.localizedDescription)")
                }
            }
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

