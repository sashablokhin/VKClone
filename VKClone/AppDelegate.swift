//
//  AppDelegate.swift
//  VKClone
//
//  Created by Alexander Blokhin on 11.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import VK_ios_sdk


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
/*
    var accessToken: String?
    var uid: String?
    let clientID = "5361337"
    let clientSecret = "BF4ocIfCrlxV40whoD8T"
    */

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch
    
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        /*
        let getToken = "https://oauth.vk.com/token?grant_type=password&client_id=\(clientID)&scope=wall&client_secret=\(clientSecret)&username=\(login)&password=\(password)"
        
        
        let authorize = "http://oauth.vk.com/authorize?client_id=\(clientID)&display=mobile&callback=auth&redirect_uri=https://oauth.vk.com/blank.html&response_type=code&scope=wall,groups,friends&response_type=token"
        
        print(authorize)
        */
        
        return true
    }
    
    /*
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        VKSdk.processOpenURL(url, fromApplication: sourceApplication)
        return true
    }*/

    /*
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        VKSdk.processOpenURL(url, fromApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String)
        
        return true
    }*/
    
    
    /*
    - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    return YES;
    }
    */

    
    
    
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
    }


}

