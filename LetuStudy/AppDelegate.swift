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
		let set = StudySet(context: self.persistentContainer.viewContext)
		set.name = "Test Set"
		set.lastOpened = Date()
		
		// add AppStat singleton
		_ = appStats()
//		let appStat = AppStat(context: self.persistentContainer.viewContext)
//		let someDayStat = DayStat(context: self.persistentContainer.viewContext)
//		someDayStat.minutes = 37
//		someDayStat.day = Date()
//		appStat.addToStats(someDayStat)
		
        return true
    }
	
	// Creates the AppStat object in the coredata stack if it doesn't exist. Checks to make sure
	// that appStat.stats contains 7 objects for the previous seven days as well, and adds/removes
	// objects when applicable.
	// Returns a sorted array of the global application stats data
	func appStats() -> [DayStat]
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
		}
		else
		{
			appStat = appStatOptional!
		}
		
		let statsSet = appStat.stats
		let cal = NSCalendar.current
		var dayBegin = cal.startOfDay(for: Date())
		fillDays(appStat: appStat, count: max(0, 7-statsSet.count), beginDate: dayBegin)
		
		let dateSortDesc = NSSortDescriptor(key: "day", ascending: false)
		var statsSorted = statsSet.sortedArray(using: [dateSortDesc]) as! [DayStat]
		
		guard let dayWeekBefore = cal.date(byAdding: .day, value: -7, to: dayBegin) else
		{
			print("Could not subtract 7 days")
			return []
		}
		dayBegin = dayWeekBefore
		
		for i in stride(from: statsSet.count-1, to: 0, by: -1)
		{
			if (statsSorted[i].day < dayBegin)
			{
				print("removed \(statsSorted[i].day)")
				statsSorted.removeLast()
			}
		}
		
		let lastDay = statsSorted.last?.day
		if (lastDay == nil)
		{
			dayBegin = cal.startOfDay(for: Date())
		}
		else
		{
			dayBegin = lastDay!
		}
		
		fillDays(appStat: appStat, count: max(0, 7-statsSet.count), beginDate: dayBegin)
		
		return statsSorted
	}
	
	private func fillDays(appStat: AppStat, count: Int, beginDate: Date)
	{
		var dayBegin = beginDate
		let cal = NSCalendar.current
		for _ in 0..<count
		{
			let dayStat = DayStat(context: self.persistentContainer.viewContext)
			dayStat.day = dayBegin
//			dayStat.minutes = 0
			dayStat.minutes = Int16.random(in: 0...60)
			appStat.addToStats(dayStat)
			
			guard let nextDay = cal.date(byAdding: .day, value: -1, to: dayBegin) else
			{
				print("Could not add 1 to dayBegin")
				return
			}
			dayBegin = nextDay
		}
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

