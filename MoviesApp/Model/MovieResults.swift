//
//  MovieResults.swift
//  MoviesApp
//
//  Created by admin on 18/07/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

struct MovieInfo: Decodable
{
    var overview: String?
    var poster_path: String?
    var title: String?
    var release_date: String?
    
    init(overview: String, title: String, poster_path: String, releaseDate:String)
    {
        self.overview = overview
        self.title = title
        self.poster_path = poster_path
        self.release_date = releaseDate
    }
}

struct MovieResults: Decodable
{
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    var results: [MovieInfo]?
    
    private enum CodingKeys: String, CodingKey
    {
        case page, total_results, total_pages, results
    }
}
