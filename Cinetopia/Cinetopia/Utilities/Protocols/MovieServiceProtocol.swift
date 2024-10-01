//
//  MovieService.swift
//  Cinetopia
//
//  Created by Bruno Moura on 05/07/24.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(language: String, page: Int) async throws -> MovieResponse
}
