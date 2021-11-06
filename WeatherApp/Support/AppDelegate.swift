//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Grifus on 20.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        copyFile()
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

    func copyFile() {
        let resourcePaths = [
            Bundle.main.url(forResource: "CitiesData", withExtension: "sqlite"),
            Bundle.main.url(forResource: "CitiesData", withExtension: "sqlite-shm"),
            Bundle.main.url(forResource: "CitiesData", withExtension: "sqlite-wal")]
        
        let destinationPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        let destUrl = [
            destinationPath.first?.appendingPathComponent("CitiesData.sqlite"),
            destinationPath.first?.appendingPathComponent("CitiesData.sqlite"),
            destinationPath.first?.appendingPathComponent("CitiesData.sqlite")]
        
        if !FileManager.default.fileExists(atPath: destUrl[0]!.path) {
            for index in 0..<resourcePaths.count {
                do {
                    try FileManager.default.copyItem(at: resourcePaths[index]!, to: destUrl[index]!)
                } catch {
                    print(error)
                }
            }
        }
    }

}

