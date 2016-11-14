//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by Christian Quicano on 11/13/16.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie");
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var movieID: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var genreIDs: NSObject?
    @NSManaged public var order: NSNumber?
    
}
