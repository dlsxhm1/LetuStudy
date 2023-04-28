//
//  StudySet+CoreDataClass.swift
//  LetuStudy
//
//  Created by Richard Homan on 3/30/23.
//
//

import Foundation
import CoreData

@objc(StudySet)
public class StudySet: NSManagedObject
{
	// Returns a sorted array of the study set stats
	func sortedStats() -> [DayStat]
	{
		let cal = NSCalendar.current
		var dayBegin = cal.startOfDay(for: Date())
		self.addToStats(StatsManager.dayFillSet(context: self.managedObjectContext!,
												count: max(0, 7-self.stats.count),
												beginDate: dayBegin))
		
		let dateSortDesc = NSSortDescriptor(key: "day", ascending: false)
		var statsSorted = self.stats.sortedArray(using: [dateSortDesc]) as! [DayStat]
		let removedObjects = NSMutableSet()
		
		guard let dayWeekBefore = cal.date(byAdding: .day, value: -7, to: dayBegin) else
		{
			print("Could not subtract 7 days")
			return []
		}
		dayBegin = dayWeekBefore
		
		for i in stride(from: self.stats.count-1, to: 0, by: -1)
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
		
		self.addToStats(StatsManager.dayFillSet(context: self.managedObjectContext!,
												count: max(0, 7-self.stats.count),
												beginDate: dayBegin))
		
		if (removedObjects.count > 0)
		{
			self.removeFromStats(removedObjects)
			Task
			{
				await AppDelegate.shared.saveContext()
			}
		}
		
		return statsSorted
	}
}
