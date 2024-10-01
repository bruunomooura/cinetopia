//
//  MoviesViewModel.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import Foundation

protocol MoviesViewModelProtocol: AnyObject {
    func searchText(content: [Movie])
    func updateData(content: [Movie])
    func insertRows(content: [Movie], _ newsIndexPaths: [IndexPath])
}

final class MoviesViewModel {
    private let movieServiceProtocol: MovieServiceProtocol
    private let movieManager: MovieManager
    private let coreData: CoreDataManagerProtocol
    private weak var delegate: MoviesViewModelProtocol?
    var isLoading: Bool = .init()
    private var language: String = "pt-BR"
    private var currentPage: Int = .zero
    public var searchText: String = "" {
        didSet {
            filterMovies()
        }
    }
    public var noResults: Bool {
        if movieManager.filteredMovies.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    init(movieServiceProtocol: MovieServiceProtocol = AppConfig.movieService(),
         movieManager: MovieManager = MovieManager.shared,
         coreData: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.movieServiceProtocol = movieServiceProtocol
        self.movieManager = movieManager
        self.coreData = coreData
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

extension MoviesViewModel {
    public func delegate(delegate: MoviesViewModelProtocol?) {
        self.delegate = delegate
    }
    
    public func filterMovies() {
        movieManager.searchMovie(searchText)
        delegate?.searchText(content: movieManager.filteredMovies)
    }
    
    //    MARK: - Initial movie data loading from TMDB API
    func loadDataMovies() async {
        isLoading = true
        currentPage += 1
        print("Página atual: ", currentPage)
        
        do {
            let moviesResponse = try await movieServiceProtocol.fetchPopularMovies(language: language, page: currentPage)
            self.isLoading = false
            self.movieManager.saveMovies(moviesResponse.results)
        } catch {
            self.isLoading = false
            print("Failed to fetch movies: \(error.localizedDescription)")
        }
        
        await updateView()
    }
    
    func updateView() async {
        await MainActor.run { [weak self] in
            guard let self = self else { return }
            self.delegate?.updateData(content: movieManager.filteredMovies)
        }
    }
    
    //    MARK: - Additional movie data loading from TMDB API
    func additionalLoadData() async {
        guard AppConfig.currentDevelopmentStatus == .production else { return }
        guard !isLoading else { return }
        guard searchText.isEmpty else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let moviesResponse = try await movieServiceProtocol.fetchPopularMovies(language: language, page: currentPage)
            print("Página atual: ", currentPage)
            
            let startIndex = self.movieManager.moviesList.count
            movieManager.appendMovies(moviesResponse.results)
            let endIndex = self.movieManager.moviesList.count
            let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.delegate?.insertRows(content: movieManager.filteredMovies, newIndexPaths)
            }
            
            isLoading = false
        } catch {
            self.isLoading = false
            currentPage -= 1
            print("Failed to fetch movies: \(error.localizedDescription)")
        }
    }
    
    public func toggleFavoriteMovie(movie: Movie) {
        movieManager.toggleFavoriteMovieStatus(movie.id) { favorite in
            switch favorite {
            case true:
                coreData.appendFavoriteMovie(movie: movie) { _ in
                }
                
            case false:
                coreData.deleteFavoriteMovie(id: Int64(movie.id)) { _ in
                }
            }
        }
    }
    
    // MARK: - Config TableView
    public var numberOfRowsInSection: Int {
        return movieManager.filteredMovies.count
    }
    
    public var limitIndexForDownloadingAdditionalData: Int {
        return movieManager.moviesList.count - 5
    }
    
    public func loadCurrentMovie(indexPath: IndexPath) -> Movie {
        return movieManager.filteredMovies[indexPath.row]
    }
}
