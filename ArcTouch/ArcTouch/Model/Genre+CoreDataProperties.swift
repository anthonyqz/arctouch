//
//  Genre+CoreDataProperties.swift
//  
//
//  Created by Christian Quicano on 11/13/16.
//
//

import Foundation
import CoreData


extension Genre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre");
    }

    @NSManaged public var genreID: Int64
    @NSManaged public var name: String?

}
