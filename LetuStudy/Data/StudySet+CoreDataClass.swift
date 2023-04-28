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
	class func fetchAll() -> [StudySet]
	{
		// load study sets
		let managedObjectContext = AppDelegate.shared.persistentContainer.viewContext
		let studySetFetchRequest = StudySet.fetchRequest()
		var fetchResult: [StudySet]?
		
		managedObjectContext.performAndWait
		{
			do
			{
				fetchResult = try managedObjectContext.fetch(studySetFetchRequest)
			}
			catch
			{
				print("Error fetching study sets: \(error)")
			}
		}
		
		guard fetchResult != nil && fetchResult!.count > 0 else
		{
			print("No study sets found")
			return []
		}
		
		return fetchResult!
	}
	
	class func dateSorted(studySets: [StudySet]) -> [StudySet]
	{
		return studySets.sorted
		{ o1,o2 in
			return o1.lastOpened > o2.lastOpened
		}
	}
	
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
