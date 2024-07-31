//
//  CoreDataManager.swift
//  Cinetopia
//
//  Created by Bruno Moura on 25/07/24.
//

import UIKit
import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    var getFavoriteMovies: [FavoriteMovie] { get }
    func appendFavoriteMovie(movie: Movie, completion: (Bool) -> Void)
    func searchFavoriteMovie(id: Int64, completion: (Bool) -> Void)
    func deleteFavoriteMovie(id: Int64, completion: (Bool) -> Void)
}

class CoreDataManager: NSObject, CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    private override init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cinetopia")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var createMovieFetchRequest: NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: String(describing: FavoriteMovie.self))
    }
    
    public var getFavoriteMovies: [FavoriteMovie] {
        let context = persistentContainer.viewContext
        let fetchRequest = createMovieFetchRequest
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let movies = try context.fetch(fetchRequest)
            return movies
        } catch {
            return []
        }
    }
    
    public func appendFavoriteMovie(movie: Movie, completion: (Bool) -> Void) {
        searchFavoriteMovie(id: Int64(movie.id)) { success in
            switch success {
            case true:
                completion(true)
                
            case false:
                let context = persistentContainer.viewContext
                let newFavoriteMovie = FavoriteMovie(context: context)
                
                newFavoriteMovie.id = Int64(movie.id)
                newFavoriteMovie.title = movie.title
                newFavoriteMovie.imageURL = movie.imageURL
                
                do {
                    try context.save()
                    completion(true)
                } catch {
                    completion(false)
                }
            }
        }
    }
    
    public func searchFavoriteMovie(id: Int64, completion: (Bool) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = createMovieFetchRequest
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.description)
        
        do {
            let movies = try context.fetch(fetchRequest)
            guard let _ = movies.first else { return completion(false) }
            completion(true)
        } catch {
            print("Nenhum filme encontrado")
            completion(false)
        }
    }
    
    public func deleteFavoriteMovie(id: Int64, completion: (Bool) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = createMovieFetchRequest
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.description)
        
        do {
            let movies = try context.fetch(fetchRequest)
            guard let movieDelete = movies.first else { return completion(false) }
            context.delete(movieDelete)
            
            try context.save()
            completion(true)
        } catch {
            print("Falha ao excluir filme. Nenhum filme encontrado")
            completion(false)
        }
    }
}
