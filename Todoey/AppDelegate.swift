//
//  AppDelegate.swift
//  Todoey
//
//  Created by Nam-Anh Vu on 1/14/18.
//  Copyright © 2018 TenTwelve. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
           
        } catch {
            print("Error initalising new Realm \(error)")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

