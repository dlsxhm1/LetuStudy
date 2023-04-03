//
//  AppDelegate.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/7/23.
//

import UIKit
import SwiftUI
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	
	lazy var persistentContainer: NSPersistentContainer =
	{
		let container = NSPersistentContainer(name: "LetuStudyDataModel")
		container.loadPersistentStores
		{ description, error in
			if let error = error
			{
				fatalError("Unable to load persistent stores: \(error)")
			}
		}
		return container
	}()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
		
		// add data set and point
		let studySetDescription = NSEntityDescription()
		studySetDescription.managedObjectClassName = "StudySet"
		studySetDescription.name = "StudySet"
		let set = StudySet(context: persistentContainer.viewContext)
		set.name = "Test Set"
		set.dateLastUsed = Date()
		
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

