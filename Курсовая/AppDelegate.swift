//
//  AppDelegate.swift
//  Курсовая
//
//  Created by Иван on 07.04.17.
//  Copyright © 2017 IvanCode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        //Регистрируем уведомления
        if #available(iOS 8, *) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
        }
        
        //UserDefaults.standard.set(true, forKey: "loggedIn")
        //UserDefaults.standard.synchronize()
        
        //Этот кусок кода используется для того, чтобы устанавливать точку входа (ViewController)
        //Если пользователь уже заходил в приложение до этого, то точка входа - View Controller с таблицей
        if UserDefaults.standard.bool(forKey: "loggedIn") == true {
            //Входим в аккаунт
            let email = UserDefaults.standard.string(forKey: "userEmail")!
            let password = UserDefaults.standard.string(forKey: "userPassword")!
            
            //Входим в аккаунт пользователя
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    print("Problems with signing in!");
                } else {
                    
                }
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let toDoVC = mainStoryboard.instantiateViewController(withIdentifier: "ToDoVC")
            appDelegate.window?.rootViewController = toDoVC
            appDelegate.window?.makeKeyAndVisible()
        }
        //Если пользователь не заходил в приложение до этого или вышел из своего аккаунта, то точка входа - View Controller с регистрацией
        else if UserDefaults.standard.bool(forKey: "loggedIn") == false {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC")
            appDelegate.window?.rootViewController = loginVC
            appDelegate.window?.makeKeyAndVisible()
        }
        
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
        //Если пользователь надумал выходить из приложения, то необходимо отправить его данные на сервер
        
        
        
        
    }
    
    


}

