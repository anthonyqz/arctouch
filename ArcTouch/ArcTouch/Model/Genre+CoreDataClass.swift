//
//  Genre+CoreDataClass.swift
//  
//
//  Created by Christian Quicano on 11/13/16.
//
//

import Foundation
import CoreData


public class Genre: NSManagedObject {
    
    //MAR:- class methods
    class func getBy(genreID:Int64) -> Genre? {
        return Genre.mr_findFirst(byAttribute: "genreID", withValue: NSNumber(value: genreID))
    }
    
    class func sync(completed:@escaping ()->()) {
        Genre.mr_truncateAll()
        ArcWebServices.syncEntity(entity: Genre.self
            , url: urlGenresMovies
            , key: kGenres
            , cleanAllData: true
            , completed: { ()->() in
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                completed()
        })
    }
    
}
