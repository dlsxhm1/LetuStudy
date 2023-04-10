//
//  StudySet+CoreDataProperties.swift
//  LetuStudy
//
//  Created by Richard Homan on 3/30/23.
//
//

import Foundation
import CoreData


extension StudySet
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudySet>
	{
        return NSFetchRequest<StudySet>(entityName: "StudySet")
    }

    @NSManaged public var lastOpened: Date
    @NSManaged public var name: String
    @NSManaged public var points: NSOrderedSet
    @NSManaged public var stats: NSSet
}

// MARK: Generated accessors for points
extension StudySet
{
    @objc(insertObject:inPointsAtIndex:)
    @NSManaged public func insertIntoPoints(_ value: StudyPoint, at idx: Int)

    @objc(removeObjectFromPointsAtIndex:)
    @NSManaged public func removeFromPoints(at idx: Int)

    @objc(insertPoints:atIndexes:)
    @NSManaged public func insertIntoPoints(_ values: [StudyPoint], at indexes: NSIndexSet)

    @objc(removePointsAtIndexes:)
    @NSManaged public func removeFromPoints(at indexes: NSIndexSet)

    @objc(replaceObjectInPointsAtIndex:withObject:)
    @NSManaged public func replacePoints(at idx: Int, with value: StudyPoint)

    @objc(replacePointsAtIndexes:withPoints:)
    @NSManaged public func replacePoints(at indexes: NSIndexSet, with values: [StudyPoint])

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: StudyPoint)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: StudyPoint)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSOrderedSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSOrderedSet)
}

// MARK: Generated accessors for stats
extension StudySet
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

extension StudySet : Identifiable
{

}
