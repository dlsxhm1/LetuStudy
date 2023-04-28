//
//  StatsView.swift
//  LetuStudy
//
//  Created by Haoming Xu on 2/8/23.
//

import SwiftUI
import CoreData
import Charts

struct ChartPoint: Identifiable
{
	let id = UUID()
	let day: Date
	let minutes: Int

	init(day: Date, minutes: Int)
	{
		let cal = NSCalendar.current
		self.day = cal.startOfDay(for: day)
		self.minutes = minutes
	}
}

struct StatsChartData: Identifiable
{
	let id = UUID()
	var points: [ChartPoint]
	let name: String
	
	init(name: String?)
	{
		self.points = []
		self.name = name ?? ""
	}
	
	init(name: String?, statsObject: StatsDataObject?)
	{
		guard let statsObjectUnwrapped = statsObject else
		{
			self.points = []
			self.name = name ?? ""
			return
		}
		
		if (name == nil)
		{
			if (statsObjectUnwrapped is StudySet)
			{
				let statsObjectUnwrapped = statsObjectUnwrapped as! StudySet
				self.name = statsObjectUnwrapped.name
			}
			else
			{
				self.name = "Total Studying"
			}
		}
		else
		{
			self.name = name!
		}
		
		self.points = []
		let stats = StatsManager.sortedStats(object: statsObjectUnwrapped)
		for p in stats
		{
			self.points.append(ChartPoint(day: p.day, minutes: Int(p.minutes)))
		}
	}
}

struct StatsView: View
{
	@State private var appStatsChartData = StatsChartData(name: "Total Studying")
	@State private var studySetsChartData = [StatsChartData]()
	
    var body: some View
	{
		NavigationStack
		{
			ScrollView
			{
				VStack
				{
					GroupBox(self.appStatsChartData.name)
					{
						Chart(self.appStatsChartData.points)
						{
							BarMark(
								x: .value("Week Day", $0.day, unit: .day),
								y: .value("Study Time", $0.minutes)
							)
						}
					}
					.frame(height: 200.0)
					.task
					{
						let appStatsChartData = StatsChartData(name: "Total Studying", statsObject: AppDelegate.shared.sharedAppStat)
						var studySetsChartData = [StatsChartData]()
						
						let studySets = StudySet.dateSorted(studySets: StudySet.fetchAll())
						for someSet in studySets
						{
							let chartData = StatsChartData(name: nil, statsObject: someSet)
							studySetsChartData.append(chartData)
						}
						self.appStatsChartData = appStatsChartData
						self.studySetsChartData = studySetsChartData
					}
					
					if (self.studySetsChartData.count > 0)
					{
						Divider()
							.frame(height: 10.0)
					}

					ForEach(self.studySetsChartData, id:\.id)
					{ chartData in
						GroupBox(chartData.name)
						{
							Chart(chartData.points)
							{
								BarMark(
									x: .value("Week Day", $0.day, unit: .day),
									y: .value("Study Time", $0.minutes)
								)
							}
						}
						.frame(height: 200.0)
					}
				}
			}
			.navigationTitle("Statistics")
			.padding(.leading)
			.padding(.trailing)
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
