//
//  CoreDataManager.swift
//  MoviesApp
//
//  Created by admin on 19/07/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {

    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Movie")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }

        return container
    }()
    
    @discardableResult
    func createMovie(name: String) -> Movie? {
        let context = persistentContainer.viewContext
        
        let movie = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context) as! Movie // NSManagedObject
        movie.name = name

        do {
            try context.save()
            return movie
        } catch let createError {
            print("Failed to create: \(createError)")
        }

        return nil
    }
    
    // FAVOURITE MOVIES
    func createFavMovie(name: String, releaseDate: String, description: String, imageUrl: String) -> MovieFavourite? {
        let context = persistentContainer.viewContext
        
        let movie = NSEntityDescription.insertNewObject(forEntityName: "MovieFavourite", into: context) as! MovieFavourite // NSManagedObject
        movie.name = name
        movie.releaseDate = releaseDate
        movie.desc = description
        movie.imageUrl = imageUrl

        do {
            try context.save()
            return movie
        } catch let createError {
            print("Failed to create: \(createError)")
        }

        return nil
    }

    func fetchFavouriteMovies() -> [MovieFavourite]? {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<MovieFavourite>(entityName: "MovieFavourite")
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let movie = try context.fetch(fetchRequest)
            return movie
        } catch let fetchError {
            print("Failed to fetch movies: \(fetchError)")
        }

        return nil
    }
    
    func deleteMovie(movie: MovieFavourite) {
        let context = persistentContainer.viewContext
        context.delete(movie)
        do {
            try context.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }
}


