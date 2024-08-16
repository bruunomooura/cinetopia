//
//  FavoriteMoviesViewModel.swift
//  Cinetopia
//
//  Created by Bruno Moura on 11/07/24.
//

import Foundation

protocol FavoriteMoviesViewModelProtocol: AnyObject {
    func updateData(content: [FavoriteMovie])
}

final class FavoriteMoviesViewModel {
    private let coreData: CoreDataManagerProtocol
    private weak var delegate: FavoriteMoviesViewModelProtocol?
    private let movieManager: MovieManager
    public var noFavorites: Bool {
        if coreData.getFavoriteMovies.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    init(coreData: CoreDataManagerProtocol = CoreDataManager.shared,
         movieManager: MovieManager = MovieManager.shared) {
        self.coreData = coreData
        self.movieManager = movieManager
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

extension FavoriteMoviesViewModel {
    public func delegate(delegate: FavoriteMoviesViewModelProtocol?) {
        self.delegate = delegate
    }
    
    public var numberOfRowsInSection: Int {
        return  coreData.getFavoriteMovies.count
    }
    
    public func loadCurrentMovie(indexPath: IndexPath) -> FavoriteMovie {
        return  coreData.getFavoriteMovies[indexPath.row]
    }
    
    public func loadDataMovies() {
        let favoriteMovies = coreData.getFavoriteMovies
        delegate?.updateData(content: favoriteMovies)
    }
    
    public func removeFavoriteMovie(id: Int64) {
        coreData.deleteFavoriteMovie(id: id) { success in
            if success {
                movieManager.toggleFavoriteMovieStatus(Int(id)) { _ in }
                delegate?.updateData(content: coreData.getFavoriteMovies)
            }
        }
    }
}
