//
//  AppDelegate.swift
//  Moody
//
//  Created by Wendell on 2022/8/13.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var persistentContainer: NSPersistentContainer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white

        createMoodyContainer { container in
            self.persistentContainer = container
            
            let rootController = RootViewController()
            rootController.managedObjectContext = container.viewContext
            
            self.window?.rootViewController = UINavigationController(rootViewController: rootController)
        }
        
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
}


