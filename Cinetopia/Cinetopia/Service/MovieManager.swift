//
//  MovieManager.swift
//  Cinetopia
//
//  Created by Bruno Moura on 17/07/24.
//

import Foundation

final class MovieManager {
    static let shared = MovieManager()
    
    private var moviesListSet: Set<Movie> = []
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
        filteredMovies = moviesList
    }
    
    public func appendMovies(_ moviesInsert: [Movie]) {
        var tempMoviesListSet: Set<Movie> = []
        for movie in moviesInsert {
            tempMoviesListSet.insert(movie)
        }
        
        moviesList.append(contentsOf: Array(tempMoviesListSet).sorted(by: { $0.popularity > $1.popularity }))
        filteredMovies = moviesList
    }
    
    public func toggleFavoriteMovieStatus(_ id: Int) {
        guard let indexMoviesList = moviesList.firstIndex(where: { $0.id == id }) else { return }
        moviesList[indexMoviesList].toggleFavoriteMovieStatus()
        guard let indexFilteredMovies = filteredMovies.firstIndex(where: { $0.id == id }) else { return }
        filteredMovies[indexFilteredMovies].toggleFavoriteMovieStatus()
    }
    
    public func removeFavoriteMovie(_ id: Int) {
        guard let indexMoviesList = moviesList.firstIndex(where: { $0.id == id }) else { return }
        moviesList[indexMoviesList].toggleFavoriteMovieStatus()
    }
}
