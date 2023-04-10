//
//  StudyPoint+CoreDataProperties.swift
//  LetuStudy
//
//  Created by Richard Homan on 3/30/23.
//
//

import Foundation
import CoreData


extension StudyPoint
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudyPoint>
	{
        return NSFetchRequest<StudyPoint>(entityName: "StudyPoint")
    }

    @NSManaged public var definition: String
    @NSManaged public var term: String
    @NSManaged public var set: StudySet
}

extension StudyPoint : Identifiable
{

}
