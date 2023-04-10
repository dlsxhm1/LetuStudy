//
//  DayStat+CoreDataProperties.swift
//  LetuStudy
//
//  Created by Richard Homan on 3/30/23.
//
//

import Foundation
import CoreData


extension DayStat
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayStat>
	{
        return NSFetchRequest<DayStat>(entityName: "DayStat")
    }

    @NSManaged public var minutes: Int16
    @NSManaged public var day: Date
    @NSManaged public var studySet: StudySet
    @NSManaged public var appStat: AppStat
}

extension DayStat : Identifiable
{

}
