//
//  AppDelegate.swift
//  Dayiato
//
//  Created by Martin Nasierowski on 16/08/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = ContainerController()
        let realm = try! Realm()
        
        if (realm.objects(Category.self).count == 0 ) {
            
            let exampleCategory = Category()
            exampleCategory.name = "Holiday"
            exampleCategory.iconName = "calendar"
            
            let exampleCategory2 = Category()
            exampleCategory2.name = "Event"
            exampleCategory2.iconName = "calendar"
            
            let exampleDayiato = Dayiato()
            exampleDayiato.title = "Christmas"
            
            var dateComponents = DateComponents()
            if ( Calendar.current.component(.year, from: Date()) == 12) {
                dateComponents.year = Calendar.current.component(.year, from: Date() + 1)
            } else {
                dateComponents.year = Calendar.current.component(.year, from: Date())
            }
            
            dateComponents.month = 12
            dateComponents.day = 25
            
            exampleDayiato.date = NSCalendar.current.date(from: dateComponents)
            exampleCategory.dayiatos.append(exampleDayiato)
            
            do {
                try realm.write {
                    realm.add(exampleCategory)
                    realm.add(exampleCategory2)
                    realm.add(exampleDayiato)
                }
            } catch {
                print("Error saving context, \(error)")
            }
        }
       
        
       
       
    
//        try! realm.write {
//            realm.deleteAll()
//        }

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


}

