//
//  MoviesViewModel.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import Foundation

protocol MoviesViewModelProtocol: AnyObject {
    func searchText()
}

class MoviesViewModel {
    private weak var delegate: MoviesViewModelProtocol?
    
    private var moviesList: [Movie] = movies
    private var filteredMovies: [Movie] = [] 
    
    init() {
        filteredMovies = moviesList
    }
    
    var searchText: String = "" {
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
}

extension MoviesViewModel {
    
    public func delegate(delegate: MoviesViewModelProtocol?) {
        self.delegate = delegate
    }
    
    private func filterMovies() {
        if searchText.isEmpty {
            filteredMovies = moviesList
        } else {
            filteredMovies = moviesList.filter { $0.title.contains(searchText) }
        }
        delegate?.searchText()
    }
    
    public var numberOfRowsInSection: Int {
        return filteredMovies.count
    }
    
    public func loadCurrentMovie(indexPath: IndexPath) -> Movie {
        return filteredMovies[indexPath.row]
    }
    
    public func heightForRow() -> CGFloat {
        return 170
    }
}
