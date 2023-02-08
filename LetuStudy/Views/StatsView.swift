//
//  StatsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI
import Charts

struct StudyCount: Identifiable {
	let id = UUID()
	let weekday: Date
	let studyMinutes: Int
	
	init(day: String, studyMinutes: Int) {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyyMMdd"
		
		self.weekday = formatter.date(from: day) ?? Date.distantPast
		self.studyMinutes = studyMinutes
	}
}

let currentWeek: [StudyCount] = [
	StudyCount(day: "20230201", studyMinutes: 42),
	StudyCount(day: "20230202", studyMinutes: 65),
	StudyCount(day: "20230203", studyMinutes: 48),
	StudyCount(day: "20230204", studyMinutes: 67),
	StudyCount(day: "20230205", studyMinutes: 64),
	StudyCount(day: "20230206", studyMinutes: 104),
	StudyCount(day: "20230207", studyMinutes: 40)
]

struct StatsView: View {
    var body: some View {
		VStack {
					GroupBox ( "Line Chart - Step count") {
						Chart(currentWeek) {
							LineMark(
								x: .value("Week Day", $0.weekday, unit: .day),
								y: .value("Study Time", $0.studyMinutes)
							)
						}
					}
					
					GroupBox ( "Bar Chart - Study Minutes") {
						Chart(currentWeek) {
							BarMark(
								x: .value("Week Day", $0.weekday, unit: .day),
								y: .value("Study Time", $0.studyMinutes)
							)
						}
					}
					
					GroupBox ( "Point Chart - Study Minutes") {
						Chart(currentWeek) {
							PointMark(
								x: .value("Week Day", $0.weekday, unit: .day),
								y: .value("Study Time", $0.studyMinutes)
							)
						}
					}
					
					GroupBox ( "Rectangle Chart - Study Minutes") {
						Chart(currentWeek) {
							RectangleMark(
								x: .value("Week Day", $0.weekday, unit: .day),
								y: .value("Study Time", $0.studyMinutes)
							)
						}
					}
					
					GroupBox ( "Line Chart - Study Minutes") {
						Chart(currentWeek) {
							AreaMark(
								x: .value("Week Day", $0.weekday, unit: .day),
								y: .value("Study Time", $0.studyMinutes)
							)
						}
					}
				}
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
