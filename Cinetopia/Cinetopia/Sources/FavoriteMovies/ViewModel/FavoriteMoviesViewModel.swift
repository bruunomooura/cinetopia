//
//  FavoriteMoviesViewModel.swift
//  Cinetopia
//
//  Created by Bruno Moura on 11/07/24.
//

import Foundation

protocol FavoriteMoviesViewModelProtocol: AnyObject {
    func updateData()
}

final class FavoriteMoviesViewModel {
    private weak var delegate: FavoriteMoviesViewModelProtocol?
    private let movieManager: MovieManager
    public var noFavorites: Bool {
        if movieManager.favoriteMovies.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    init(movieManager: MovieManager = MovieManager.shared) {
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
        return  movieManager.favoriteMovies.count
    }
    
    public func loadCurrentMovie(indexPath: IndexPath) -> Movie {
        return  movieManager.favoriteMovies[indexPath.row]
    }
    
    public func removeFavoriteMovie(id: Int) {
        movieManager.removeFavoriteMovie(id)
    }
}
