//
//  StatsManager.swift
//  LetuStudy
//
//  Created by Richard Homan on 4/25/23.
//

import Foundation

class StatsManager
{
	static let shared: StatsManager = StatsManager()
	
	private var appStatBeginDate: Date?
	
	func beginAppStat()
	{
		guard appStatBeginDate == nil else
		{
			print("AppStat is already tracking statistics")
			return
		}
		appStatBeginDate = Date()
	}
	
	func endAppStat()
	{
		guard var appStatBeginDateUnwrapped = appStatBeginDate else
		{
			print("Could not end AppStat statistics: no begin date")
			return
		}
		
		let appStats = AppDelegate.sharedDelegate().appStats()
		let cal = NSCalendar.current
		let endDate = Date()
		let startOfDay = cal.startOfDay(for: endDate)
		
		// case where the user opened the app on a day, and kept it open while the clock passed midnight
		if (appStatBeginDateUnwrapped < startOfDay)
		{
			let minutes = (Int(startOfDay.timeIntervalSinceReferenceDate) - Int(appStatBeginDateUnwrapped.timeIntervalSinceReferenceDate))// / 60
			// add to previous day
			appStats[1].minutes += Int16(minutes)
			appStatBeginDateUnwrapped = startOfDay
		}
		
		let minutes = (Int(endDate.timeIntervalSinceReferenceDate) - Int(appStatBeginDateUnwrapped.timeIntervalSinceReferenceDate))// / 60
		// add to current day
		appStats[0].minutes += Int16(minutes)
		Task
		{
			await AppDelegate.sharedDelegate().saveContext()
		}
		
		appStatBeginDate = nil
	}
	
	func beginStudyStat(studySet: StudySet)
	{
		
	}
	
	func endStudyStat(studySet: StudySet)
	{
		
	}
}
