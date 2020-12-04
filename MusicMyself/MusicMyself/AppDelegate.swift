//
//  AppDelegate.swift
//  MusicMyself
//
//  Created by XYU on 02/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        copyDb()
        creatFileFolder()
        
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

    func copyDb() {
        let dbSourceURL = Bundle.main.url(forResource: "musicMyselfDB", withExtension: "sqlite")
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        let dbDestURL = URL(fileURLWithPath: documentsDirectory.appending("/musicMyselfDB.sqlite"))
        print(dbDestURL.absoluteString)
        
        //test
        if FileManager.default.fileExists(atPath: dbDestURL.path){
            do {
                try FileManager.default.removeItem(at: dbDestURL)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        if !FileManager.default.fileExists(atPath: dbDestURL.path){
            do {
                try FileManager.default.copyItem(at: dbSourceURL!, to: dbDestURL)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func creatFileFolder() {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("Files")
            
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create document directory")
                }
            }
            NSLog("Document directory is \(filePath)")
        }
    }
}
