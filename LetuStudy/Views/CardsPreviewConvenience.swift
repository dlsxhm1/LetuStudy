//
//  CardsPreviewConvenience.swift
//  LetuStudy
//
//  Created by Richard Homan on 4/19/23.
//

import SwiftUI
import CoreData

struct CardsPreviewConvenience
{
	static func newStudySet(name: String) -> StudySet
	{
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let moc = appDelegate.persistentContainer.viewContext

		let newSet = StudySet(context: moc)
		newSet.name = name
		return newSet
	}
	
	static func emptyStudySet() -> StudySet
	{
		let studySet = newStudySet(name: "Empty")
		return studySet
	}
	
	static func generatedStudySet() -> StudySet
	{
		let studySet = newStudySet(name: "Generated")
		let pointsCount = 5
		
		for i in 1...pointsCount
		{
			let studyPoint = StudyPoint(context: studySet.managedObjectContext!)
			studyPoint.term = "Term \(i)"
			studyPoint.definition = "Definition \(i)"
			studySet.addToPoints(studyPoint)
		}
		
		return studySet
	}
}
