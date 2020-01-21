//
//  Events+CoreDataProperties.swift
//  BorderlessFinderIOS
//
//  Created by Jack Gee on 27/12/2019.
//  Copyright © 2019 computerscience. All rights reserved.
//
//

import Foundation
import CoreData


extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events")
    }

    @NSManaged public var name: String?
    @NSManaged public var society: String?
    @NSManaged public var location: String?
    @NSManaged public var type: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: String?
    @NSManaged public var time: String?

}
