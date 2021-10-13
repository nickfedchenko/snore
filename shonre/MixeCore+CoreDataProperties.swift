//
//  MixeCore+CoreDataProperties.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//
//

import Foundation
import CoreData


extension MixeCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MixeCore> {
        return NSFetchRequest<MixeCore>(entityName: "MixeCore")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageFileName: String?
    @NSManaged public var imageLink: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}

extension MixeCore : Identifiable {

}
