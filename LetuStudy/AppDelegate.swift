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
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
	public lazy var sharedAppStat: AppStat =
	{
		let appStatFetchRequest = AppStat.fetchRequest()
		var fetchResult: [AppStat]?
		
		self.persistentContainer.viewContext.performAndWait
		{
			do
			{
				fetchResult = try self.persistentContainer.viewContext.fetch(appStatFetchRequest)
			}
			catch
			{
				print("Error fetching 'AppStat': \(error)")
			}
		}

		let appStatOptional = fetchResult?.first
		let appStat: AppStat
		if (appStatOptional == nil)
		{
			// add new AppStat
			appStat = AppStat(context: self.persistentContainer.viewContext)
			Task
			{
				await self.saveContext()
			}
		}
		else
		{
			appStat = appStatOptional!
		}
		
		return appStat
	}()
	
	static let shared: AppDelegate =
	{
		return UIApplication.shared.delegate as! AppDelegate
	}()
	
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
	
	func saveContext() async
	{
		self.persistentContainer.viewContext.performAndWait
		{
			do
			{
				try self.persistentContainer.viewContext.save()
			}
			catch
			{
				print("Error saving changes: \(error)")
			}
		}
	}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
	{

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
		
		// add data set and point
//		let set = StudySet(context: self.persistentContainer.viewContext)
//		set.name = "Test Set"
//		set.lastOpened = Date()
		
		// add AppStat singleton
		_ = sharedAppStat
//		let appStat = AppStat(context: self.persistentContainer.viewContext)
//		let someDayStat = DayStat(context: self.persistentContainer.viewContext)
//		someDayStat.minutes = 37
//		someDayStat.day = Date()
//		appStat.addToStats(someDayStat)
		
        return true
    }

//    func applicationDidEnterBackground(_ application: UIApplication)
//	{
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication)
//	{
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
	
	func applicationWillResignActive(_ application: UIApplication)
	{
		StatsManager.shared.endAppStat()
	}

    func applicationDidBecomeActive(_ application: UIApplication)
	{
		StatsManager.shared.beginAppStat()
    }
}

