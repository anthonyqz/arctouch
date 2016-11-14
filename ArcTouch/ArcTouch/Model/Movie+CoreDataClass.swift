//
//  Movie+CoreDataClass.swift
//
//
//  Created by Christian Quicano on 11/13/16.
//
//

import Foundation
import CoreData
import MagicalRecord

@objc(Movie)
class Movie: NSManagedObject {
    
    //MAR:- class methods
    class func getAll(bySearchText searchText:String, orderBy:String) -> [Movie] {
        if searchText.characters.count > 0 {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            return (Movie.mr_findAllSorted(by: orderBy, ascending: true, with: predicate) as? [Movie]) ?? []
        }
        return (Movie.mr_findAllSorted(by: orderBy, ascending: true) as? [Movie]) ?? []
    }
    
    class func sync(withPage page:Int, completed:@escaping ()->()) {
        let newPage = page < 1 ? 1 : page //force 1
        let cleanAll = newPage == 1 ? true : false //force clean all data if the page is 1
        let url = ArcWebServices.urlForUpcomingMovies(page: newPage)
        ArcWebServices.syncEntity(entity: Movie.self
            , url: url
            , key: kResults
            , cleanAllData: cleanAll
            , completed: completed)
    }
    
    //MAR:- readonly properties
    var genres:String {
        var string = ""
        if let ids = genreIDs as? [Int] {
            for id in ids {
                if let name = Genre.getBy(genreID: Int64(id))?.name {
                    let text = string.characters.count == 0 ? name : ", \(name)"
                    string.append(text)
                }
            }
        }
        return string
    }
    
}
