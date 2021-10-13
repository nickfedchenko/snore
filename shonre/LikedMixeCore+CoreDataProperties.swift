//
//  LikedMixeCore+CoreDataProperties.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//
//

import Foundation
import CoreData


extension LikedMixeCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedMixeCore> {
        return NSFetchRequest<LikedMixeCore>(entityName: "LikedMixeCore")
    }

    @NSManaged public var mixeId: String?

}

extension LikedMixeCore : Identifiable {

}
