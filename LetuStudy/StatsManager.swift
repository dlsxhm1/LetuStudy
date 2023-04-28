//
//  StatsManager.swift
//  LetuStudy
//
//  Created by Richard Homan on 4/25/23.
//

import Foundation
import CoreData

class StatsManager
{
	static let shared: StatsManager = StatsManager()
	
	private var trackingStudySet: StudySet?
	private var beginDate: Date?
	
	func beginStudyStat(studySet: StudySet)
	{
		guard trackingStudySet == nil else
		{
			print("Already tracking statistics for \(studySet.name)")
			return
		}
		trackingStudySet = studySet
		self.beginAppStat()
	}
	
	func endStudyStat()
	{
		self.endAppStat()
		trackingStudySet = nil
	}
	
	func beginAppStat()
	{
		guard trackingStudySet != nil else
		{
			return
		}
		guard beginDate == nil else
		{
			print("AppStat is already tracking statistics")
			return
		}
		beginDate = Date()
	}
	
	func endAppStat()
	{
		guard var appStatBeginDateUnwrapped = beginDate else
		{
			print("Could not end AppStat statistics: no begin date")
			return
		}
		
		let appStats = StatsManager.sortedStats(object: AppDelegate.shared.sharedAppStat)
		let studySetStats = StatsManager.sortedStats(object: self.trackingStudySet!)
		let cal = NSCalendar.current
		let endDate = Date()
		let startOfDay = cal.startOfDay(for: endDate)
		
		// case where the user opened the app on a day, and kept it open while the clock passed midnight
		if (appStatBeginDateUnwrapped < startOfDay)
		{
			let minutes = (Int(startOfDay.timeIntervalSinceReferenceDate) - Int(appStatBeginDateUnwrapped.timeIntervalSinceReferenceDate))// / 60
			// add to previous day
			appStats[1].minutes += Int16(minutes)
			studySetStats[1].minutes += Int16(minutes)
			appStatBeginDateUnwrapped = startOfDay
		}
		
		let minutes = (Int(endDate.timeIntervalSinceReferenceDate) - Int(appStatBeginDateUnwrapped.timeIntervalSinceReferenceDate))// / 60
		// add to current day
		appStats[0].minutes += Int16(minutes)
		studySetStats[0].minutes += Int16(minutes)
		Task
		{
			await AppDelegate.shared.saveContext()
		}
		
		beginDate = nil
	}
	
	class func dayFillSet(context: NSManagedObjectContext, count: Int, beginDate: Date) -> NSSet
	{
		let buildSet = NSMutableSet(capacity: count)
		var dayBegin = beginDate
		let cal = NSCalendar.current
		for _ in 0..<count
		{
			let dayStat = DayStat(context: context)
			dayStat.day = dayBegin
			dayStat.minutes = 0
//			dayStat.minutes = Int16.random(in: 0...60)
			buildSet.add(dayStat)
			
			guard let nextDay = cal.date(byAdding: .day, value: -1, to: dayBegin) else
			{
				print("Could not add 1 to dayBegin")
				return NSSet()
			}
			dayBegin = nextDay
		}
		
		return buildSet
	}
	
	// Returns a sorted array of the appstats
	static func sortedStats(object:StatsDataObject) -> [DayStat]
	{
		let cal = NSCalendar.current
		var dayBegin = cal.startOfDay(for: Date())
		object.addToStats(StatsManager.dayFillSet(context: object.managedObjectContext!,
												count: max(0, 7-object.stats.count),
												beginDate: dayBegin))

		let dateSortDesc = NSSortDescriptor(key: "day", ascending: false)
		var statsSorted = object.stats.sortedArray(using: [dateSortDesc]) as! [DayStat]
		let removedObjects = NSMutableSet()

		guard let dayWeekBefore = cal.date(byAdding: .day, value: -7, to: dayBegin) else
		{
			print("Could not subtract 7 days")
			return []
		}
		dayBegin = dayWeekBefore

		for i in stride(from: object.stats.count-1, to: 0, by: -1)
		{
			if (statsSorted[i].day < dayBegin)
			{
				print("removed \(statsSorted[i].day)")
				removedObjects.add(statsSorted.last!)
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

		object.addToStats(StatsManager.dayFillSet(context: object.managedObjectContext!,
												count: max(0, 7-object.stats.count),
												beginDate: dayBegin))

		if (removedObjects.count > 0)
		{
			object.removeFromStats(removedObjects)
			Task
			{
				await AppDelegate.shared.saveContext()
			}
		}

		return statsSorted
	}
}

protocol StatsDataObject: NSManagedObject
{
	func addToStats(_ values: NSSet)
	func removeFromStats(_ values: NSSet)
	
	var stats: NSSet { get }
}
