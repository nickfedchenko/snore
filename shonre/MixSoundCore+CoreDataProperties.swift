//
//  MixSoundCore+CoreDataProperties.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//
//

import Foundation
import CoreData


extension MixSoundCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MixSoundCore> {
        return NSFetchRequest<MixSoundCore>(entityName: "MixSoundCore")
    }

    @NSManaged public var possition: Int64
    @NSManaged public var soundID: String?
    @NSManaged public var volume: Float
    @NSManaged public var mixeCore: MixeCore?

}

extension MixSoundCore : Identifiable {

}
