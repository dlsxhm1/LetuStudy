//
//  AppStat+CoreDataProperties.swift
//  LetuStudy
//
//  Created by Richard Homan on 3/30/23.
//
//

import Foundation
import CoreData

extension AppStat
{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppStat>
	{
        return NSFetchRequest<AppStat>(entityName: "AppStat")
    }

    @NSManaged public var stats: NSSet
}

// MARK: Generated accessors for stats
extension AppStat
{
    @objc(addStatsObject:)
    @NSManaged public func addToStats(_ value: DayStat)

    @objc(removeStatsObject:)
    @NSManaged public func removeFromStats(_ value: DayStat)

    @objc(addStats:)
    @NSManaged public func addToStats(_ values: NSSet)

    @objc(removeStats:)
    @NSManaged public func removeFromStats(_ values: NSSet)
}

extension AppStat : Identifiable
{

}
