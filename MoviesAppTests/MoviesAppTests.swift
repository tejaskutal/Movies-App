//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by admin on 20/07/20.
//  Copyright © 2020 admin. All rights reserved.
//
@testable import MoviesApp
import XCTest

class MoviesAppTests: XCTestCase {

    func test_create_constantAPIurl() {
        XCTAssertEqual(Constant.TRENDING_MOVIE_URL, "https://run.mocky.io/v3/0bfb7e3f-3cf5-4df1-9a97-42b6c8774fd6")
    }
    
    func test_create_constantPosterurl() {
            XCTAssertEqual(Constant.MOVIE_POSTER_PATH, "https://image.tmdb.org/t/p/w154")
    }
}
