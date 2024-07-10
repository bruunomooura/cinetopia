//
//  MoviesViewModel.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import Foundation

protocol MoviesViewModelProtocol: AnyObject {
    func searchText()
    func updateData()
    func insertRows(_ newsIndexPaths: [IndexPath])
}

final class MoviesViewModel {
    private let movieService: MovieService
    private weak var delegate: MoviesViewModelProtocol?
    private var moviesList: [Movie] = []
    private var filteredMovies: [Movie] = []
    var isLoading: Bool = .init()
    private var language: String = "pt-BR"
    private var currentPage: Int = .zero
    public var searchText: String = "" {
        didSet {
            filterMovies()
        }
    }
    public var noResults: Bool {
        if filteredMovies.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    init(movieService: MovieService = AppConfig.movieService()) {
        self.movieService = movieService
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

extension MoviesViewModel {
    
    public func delegate(delegate: MoviesViewModelProtocol?) {
        self.delegate = delegate
    }
    
    private func filterMovies() {
        if searchText.isEmpty {
            filteredMovies = moviesList
        } else {
            filteredMovies = moviesList.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        delegate?.searchText()
    }
    
    //    MARK: - Initial movie data loading from TMDB API
    func loadDataMovies() {
        isLoading = true
        currentPage += 1
        print("Página atual: ", currentPage)
        movieService.fetchPopularMovies(language: language, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moviesResponse):
                self.isLoading = false
                self.moviesList = moviesResponse.results
                
            case .failure(let error):
                self.isLoading = false
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
            self.updateView()
        }
    }
    
    func updateView() {
        self.filteredMovies = self.moviesList
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.updateData()
        }
    }
    
    //    MARK: - Additional movie data loading from TMDB API
    func additionalLoadData() {
        guard AppConfig.currentDevelopmentStatus == .production else { return }
        guard !isLoading else { return }
        isLoading = true
        currentPage += 1
        
        movieService.fetchPopularMovies(language: language, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            print("Página atual: ", currentPage)
            
            switch result {
            case .success(let moviesResponse):
                self.isLoading = false
                let startIndex = self.moviesList.count
                self.moviesList.append(contentsOf: moviesResponse.results)
                let endIndex = self.moviesList.count
                self.filteredMovies = self.moviesList
                let newIndexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.insertRows(newIndexPaths)
                }
                
            case.failure(let error):
                self.isLoading = false
                currentPage -= 1
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Config TableView
    public var numberOfRowsInSection: Int {
        return filteredMovies.count
    }
    
    public var limitIndexForDownloadingAdditionalData: Int {
        return moviesList.count - 5
    }
    
    public func loadCurrentMovie(indexPath: IndexPath) -> Movie {
        return filteredMovies[indexPath.row]
    }
    
    public func heightForRow() -> CGFloat {
        return 170
    }
}
