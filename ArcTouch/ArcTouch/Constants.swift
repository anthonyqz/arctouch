//
//  Constants.swift
//  ArcTouch
//
//  Created by Christian Quicano on 11/13/16.
//  Copyright © 2016 ca9z. All rights reserved.
//

import Foundation

//MARK:- keys
let kPage       = "$PAGE$"
let kResults    = "results"
let kGenres     = "genres"
let kCurrentPage    = "currentPage"
let kOrder      = "order"

//MARK:- urls web services
let urlBase             = "http://api.themoviedb.org/3"
let urlImage            = "https://image.tmdb.org/t/p/w300"
let apiKey              = "1f54bd990f1cdfb230adb312546d765d"
let urlUpcomingMovies   = "\(urlBase)/movie/upcoming?api_key=\(apiKey)&page=\(kPage)"
let urlGenresMovies     = "\(urlBase)/genre/movie/list?api_key=\(apiKey)&language=en-US"
