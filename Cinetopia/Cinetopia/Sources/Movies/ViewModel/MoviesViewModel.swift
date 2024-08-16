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
    func loadDataMovies() {
        isLoading = true
        currentPage += 1
        print("Página atual: ", currentPage)
        movieServiceProtocol.fetchPopularMovies(language: language, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let moviesResponse):
                self.isLoading = false
                self.movieManager.saveMovies(moviesResponse.results)
                
            case .failure(let error):
                self.isLoading = false
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
            self.updateView()
        }
    }
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.updateData(content: movieManager.filteredMovies)
        }
    }
    
    //    MARK: - Additional movie data loading from TMDB API
    func additionalLoadData() {
        guard AppConfig.currentDevelopmentStatus == .production else { return }
        guard !isLoading else { return }
        guard searchText.isEmpty else { return }
        isLoading = true
        currentPage += 1
        
        movieServiceProtocol.fetchPopularMovies(language: language, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            print("Página atual: ", currentPage)
            
            switch result {
            case .success(let moviesResponse):
                self.isLoading = false
                let startIndex = self.movieManager.moviesList.count
                self.movieManager.appendMovies(moviesResponse.results)
                let endIndex = self.movieManager.moviesList.count
                let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.insertRows(content: movieManager.filteredMovies, newIndexPaths)
                }
                
            case.failure(let error):
                self.isLoading = false
                currentPage -= 1
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
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
    
//    public func heightForRow() -> CGFloat {
//        return 170
//    }
}
