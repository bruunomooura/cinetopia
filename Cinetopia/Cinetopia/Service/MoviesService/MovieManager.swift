//
//  MovieManager.swift
//  Cinetopia
//
//  Created by Bruno Moura on 17/07/24.
//

import Foundation

protocol MovieManagerProtocol: AnyObject {
    var moviesListSet: Set<Movie> { get }
    var moviesList: [Movie] { get }
    var filteredMovies: [Movie] { get }
    var favoriteMovies: [Movie] { get }
    func searchMovie(_ searchText: String)
    func saveMovies(_ movies: [Movie])
    func appendMovies(_ moviesInsert: [Movie])
    func toggleFavoriteMovieStatus(_ ind: Int, completion: (Bool) -> Void)
    func removeFavoriteMovie(_ id: Int)
}

final class MovieManager: MovieManagerProtocol {
    static let shared = MovieManager()
    private let coreData: CoreDataManagerProtocol
    
    init(coreData: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.coreData = coreData
    }
    
    private(set) var moviesListSet: Set<Movie> = []
    private(set) var moviesList: [Movie] = []
    private(set) var filteredMovies: [Movie] = []
    var favoriteMovies: [Movie] {
        return moviesList.filter { $0.favoriteMovie == true }
    }
    
    public func searchMovie(_ searchText: String) {
        if searchText.isEmpty {
            filteredMovies = moviesList
        } else {
            filteredMovies = moviesList.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    public func saveMovies(_ movies: [Movie]) {
        moviesListSet = Set(movies)
        moviesList = Array(moviesListSet).sorted(by: { $0.popularity > $1.popularity })
        for movie in moviesList {
            coreData.searchFavoriteMovie(id: Int64(movie.id)) { favorite in
                if favorite {
                    guard let indexMoviesList = moviesList.firstIndex(where: { $0.id == movie.id }) else { return }
                    moviesList[indexMoviesList].toggleFavoriteMovieStatus()
                }
            }
        }
        filteredMovies = moviesList
    }
    
    public func appendMovies(_ moviesInsert: [Movie]) {
        var tempMoviesListSet: Set<Movie> = []
        for movie in moviesInsert {
            tempMoviesListSet.insert(movie)
        }
        
        moviesListSet.formUnion(tempMoviesListSet)
        moviesList = Array(moviesListSet).sorted(by: { $0.popularity > $1.popularity })
        
        for movie in moviesList {
            if movie.favoriteMovie == false {
                coreData.searchFavoriteMovie(id: Int64(movie.id)) { favorite in
                    if favorite {
                        guard let indexMoviesList = moviesList.firstIndex(where: { $0.id == movie.id }) else { return }
                        moviesList[indexMoviesList].toggleFavoriteMovieStatus()
                    }
                }
            }
        }
        filteredMovies = moviesList
    }
    
    public func toggleFavoriteMovieStatus(_ id: Int, completion: (Bool) -> Void) {
        guard let indexMoviesList = moviesList.firstIndex(where: { $0.id == id }) else { return }
        moviesList[indexMoviesList].toggleFavoriteMovieStatus()
        guard let indexFilteredMovies = filteredMovies.firstIndex(where: { $0.id == id }) else { return }
        filteredMovies[indexFilteredMovies].toggleFavoriteMovieStatus()
        
        if moviesList[indexMoviesList].favoriteMovie == true {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    public func removeFavoriteMovie(_ id: Int) {
        guard let indexMoviesList = moviesList.firstIndex(where: { $0.id == id }) else { return }
        moviesList[indexMoviesList].toggleFavoriteMovieStatus()
    }
}
