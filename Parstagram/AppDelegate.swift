//
//  AppDelegate.swift
//  Parstagram
//
//  Created by Kimberly Le on 10/4/20.
//

//app delegate is what runs when the user launches the app
import UIKit
import Parse
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "dNbbuGQw32aEjfaN3E3byyz1GHAZguv6W0sUNFB4"
                $0.clientKey = "PyMBsnXZIX6NdHGiJswwN2XvnV9CAjYjgtDsBHmE"
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        
        // --- end copy
        //check to see if the user is logged in
            if PFUser.current() !=  nil{ //and if they are don't take them to the login page but take them to the navigation controller which has the view controller
                let main = UIStoryboard(name: "Main", bundle: nil)
                let feedNavigationController = main.instantiateViewController(withIdentifier: "FeedNavigationController") //this instantiates FeedNavigationController to have an instance of this nav controller
                
            
                
                window?.rootViewController = feedNavigationController //change the rootViewController to immediately show the feedNavController
            
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

