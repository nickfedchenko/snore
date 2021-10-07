//
//  SoundCore+CoreDataProperties.swift
//  shonre
//
//  Created by Александр Шендрик on 06.10.2021.
//
//

import Foundation
import CoreData


extension SoundCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SoundCore> {
        return NSFetchRequest<SoundCore>(entityName: "SoundCore")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var length: Double
    @NSManaged public var timeInBed: Double
    @NSManaged public var started: Date?
    @NSManaged public var stoped: Date?
    @NSManaged public var fileName: String?
    @NSManaged public var timeNoSnoring: Double
    @NSManaged public var timeSnoringRed: Double
    @NSManaged public var timeSnoringYellow: Double

}

extension SoundCore : Identifiable {

}
