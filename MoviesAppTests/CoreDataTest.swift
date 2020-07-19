//
//  CoreDataTest.swift
//  MoviesAppTests
//
//  Created by admin on 20/07/20.
//  Copyright © 2020 admin. All rights reserved.
//

@testable import MoviesApp
import XCTest
import CoreData


class CoreDataTest: XCTestCase {
    var sut: CoreDataManager!
    override func setUp() {
        super.setUp()
        sut = CoreDataManager()
    }
    
    let persistentContainerFake: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self) as AnyClass)] )!
        return managedObjectModel
    }()
    
    
    func test_create_favMovie() {
        let todo = sut.createFavMovie(name: "ABCDE", releaseDate: "12/02/1992", description: "ksjdhfkhksd", imageUrl: "asd/asdfas/ad")
        XCTAssertNotNil( todo )
    }
    
    func test_fetch_all_favMovie() {
        let results = sut.fetchFavouriteMovies()
        XCTAssertEqual(results!, [MovieFavourite]())
    }
    
    func test_delete_favMovie() {
        let items = sut.fetchFavouriteMovies()
        let item = items?[0] ?? nil
        sut.deleteMovie(movie: item!)
    }
}
