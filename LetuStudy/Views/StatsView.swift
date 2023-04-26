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
		let cal = NSCalendar.current
		self.weekday = cal.startOfDay(for: day)
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
					GroupBox ("Total Studying")
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
						Task
						{
							await fetchTotalMinutes()
						}
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
		let sortedStats = await (UIApplication.shared.delegate as! AppDelegate).appStats()
		totalMinutes = [StudyCount]()
		for stat in sortedStats
		{
			let studyCount = StudyCount(day: stat.day, studyMinutes: Int(stat.minutes))
			totalMinutes.append(studyCount)
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
