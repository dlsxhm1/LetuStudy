//
//  StatsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI
import CoreData
import Charts

struct StudyCount: Identifiable
{
	let id = UUID()
	let weekday: Date
	let studyMinutes: Int
	
	init(day: Date, studyMinutes: Int)
	{
		self.weekday = day
		self.studyMinutes = studyMinutes
	}
}

//let currentWeek: [StudyCount] = [
//	StudyCount(day: "20230201", studyMinutes: 42),
//	StudyCount(day: "20230202", studyMinutes: 65),
//	StudyCount(day: "20230203", studyMinutes: 48),
//	StudyCount(day: "20230204", studyMinutes: 67),
//	StudyCount(day: "20230205", studyMinutes: 64),
//	StudyCount(day: "20230206", studyMinutes: 104),
//	StudyCount(day: "20230207", studyMinutes: 40)
//]


struct StatsView: View
{
	let weekDates: [Date] =
	{
		var buildWeekDates = [Date]()
		
		let cal = NSCalendar.current
		var date = cal.startOfDay(for:Date())
		
		for i in 1...7
		{
			// get day
			buildWeekDates.append(date)
			// move back by 1 day
			date = cal.date(byAdding: .day, value: -1, to: date) ?? Date()
		}
		
		return buildWeekDates
	}()
	
	@State var totalMinutes = [StudyCount]()
	
	var persistentStore: NSPersistentContainer =
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer
	}()
	
    var body: some View
	{
		NavigationStack
		{
			ScrollView
			{
				VStack
				{
					GroupBox ( "Total Study Minutes")
					{
						Chart(self.totalMinutes)
						{
							BarMark(
								x: .value("Week Day", $0.weekday, unit: .day),
								y: .value("Study Time", $0.studyMinutes)
							)
						}
					}
					.frame(height: 200.0)
					.onAppear()
					{
						await fetchTotalMinutes()
					}
					
//					GroupBox ( "Bar Chart - Study Minutes") {
//						Chart(currentWeek) {
//							LineMark(
//								x: .value("Week Day", $0.weekday, unit: .day),
//								y: .value("Study Time", $0.studyMinutes)
//							)
//						}
//					}
//					.frame(height: 200.0)
//
//					GroupBox ( "Point Chart - Study Minutes") {
//						Chart(currentWeek) {
//							PointMark(
//								x: .value("Week Day", $0.weekday, unit: .day),
//								y: .value("Study Time", $0.studyMinutes)
//							)
//						}
//					}
//					.frame(height: 200.0)
//
//					GroupBox ( "Rectangle Chart - Study Minutes") {
//						Chart(currentWeek) {
//							RectangleMark(
//								x: .value("Week Day", $0.weekday, unit: .day),
//								y: .value("Study Time", $0.studyMinutes)
//							)
//						}
//					}
//					.frame(height: 200.0)
//
//					GroupBox ( "Line Chart - Study Minutes") {
//						Chart(currentWeek) {
//							AreaMark(
//								x: .value("Week Day", $0.weekday, unit: .day),
//								y: .value("Study Time", $0.studyMinutes)
//							)
//						}
//					}
//					.frame(height: 200.0)
//
				}
			}
			.navigationTitle("Statistics")
		}
		
    }
	
	func fetchTotalMinutes() async
	{
		if (self.totalMinutes.count != 7)
		{
			self.totalMinutes.removeAll(keepingCapacity: true)
		}
		
		let appStatFetchRequest = AppStat.fetchRequest()
		var fetchResult: [AppStat]?
		
		persistentStore.viewContext.performAndWait
		{
			do
			{
				fetchResult = try persistentStore.viewContext.fetch(appStatFetchRequest)
			}
			catch
			{
				print("Error fetching 'AppStat': \(error)")
			}
		}
		
		guard fetchResult != nil && fetchResult!.count > 0 else
		{
			print("Error fetching 'AppStat'")
			return
		}
		
		let dayStats = fetchResult?.first?.stats
		
		for i in 0...6
		{
			let day = self.weekDates[i]
			
			self.totalMinutes.append(StudyCount(day: day, studyMinutes: 37))
		}
	}
}

struct StatsView_Previews: PreviewProvider
{
    static var previews: some View
	{
        StatsView()
    }
}
