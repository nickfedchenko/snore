//
//  SingleWaveCore+CoreDataProperties.swift
//  shonre
//
//  Created by Александр Шендрик on 06.10.2021.
//
//

import Foundation
import CoreData


extension SingleWaveCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleWaveCore> {
        return NSFetchRequest<SingleWaveCore>(entityName: "SingleWaveCore")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var volume: Float
    @NSManaged public var number: Int64
    @NSManaged public var color: String?
    @NSManaged public var sound: SoundCore?

}

extension SingleWaveCore : Identifiable {

}
