//
//  AppDelegate.swift
//  modulo8final
//
//  Created by Raymundo Peralta on 3/27/17.
//  Copyright © 2017 Raymundo Peralta. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var directorioDocuments:NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1] // devuelve el ultimo, [0] regresa el primero
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Override point for customization after application launch.
        // copiar el json que se agregó como recurso, a la ubicacion documents
        // 1. encontrar la base de datos como recurso
        let origen = NSBundle.mainBundle().pathForResource("frutasdata", ofType: "json")
        print(origen)
        // 2. obten la ubicación destino
        let destino = directorioDocuments.URLByAppendingPathComponent("frutas.json")
        print(">>>")
        print(destino)
        // 3. validar si el json no existe en el destino
        if NSFileManager.defaultManager().fileExistsAtPath(destino.path!)
        {
            return true
        }
        else { // 4. copiar el json origen al destino
            do {
                try NSFileManager.defaultManager().copyItemAtPath(origen!, toPath: destino.path!)
            }
            catch {
                print("ya valio")
                abort()
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }

}

