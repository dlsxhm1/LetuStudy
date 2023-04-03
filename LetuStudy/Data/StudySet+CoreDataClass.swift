//
//  StudySet+CoreDataClass.swift
//  LetuStudy
//
//  Created by Richard Homan on 3/29/23.
//
//

import Foundation
import CoreData

@objc(StudySet)
public class StudySet: NSManagedObject {
	public var wrappedName: String
	{
		name ?? "Test Set"
	}
}
