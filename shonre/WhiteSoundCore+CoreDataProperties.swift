//
//  WhiteSoundCore+CoreDataProperties.swift
//  shonre
//
//  Created by Александр Шендрик on 12.10.2021.
//
//

import Foundation
import CoreData


extension WhiteSoundCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WhiteSoundCore> {
        return NSFetchRequest<WhiteSoundCore>(entityName: "WhiteSoundCore")
    }

    @NSManaged public var fbid: String?
    @NSManaged public var fileName: String?
    @NSManaged public var imageLink: String?
    @NSManaged public var imgFileName: String?
    @NSManaged public var imgName: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?

}

extension WhiteSoundCore : Identifiable {

}
