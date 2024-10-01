//
//  TMDBServiceManager.swift
//  Cinetopia
//
//  Created by Bruno Moura on 27/06/24.
//

import Foundation

final class TMDBServiceManager: MovieServiceProtocol {
    private var dataTask: URLSessionDataTask?
    private let session: URLSession
    private let decoderService: JSONDecoderService
    
    init(session: URLSession = .shared, decoderService: JSONDecoderService = JSONDecoderService()) {
        self.session = session
        self.decoderService = decoderService
    }
    
    deinit {
        print(Self.self, "- Deallocated")
        dataTask?.cancel()
    }
    
    func fetchPopularMovies(language: String, page: Int) async throws -> MovieResponse {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular") else { throw MoviesLoadingError.errorReceivingData }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { throw MoviesLoadingError.errorReceivingData }
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "page", value: String(page)),
        ]
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url ?? url)
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(APIKeys.tmdbAPIToken)"
        ]
        
        let (data, response) =  try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw MoviesLoadingError.errorReceivingData }
        
            do {                
                let movies = try decoderService.decode(MovieResponse.self, from: data)
                return movies
            } catch {
                throw error
            }
    }
}

// Enum that represents the possible errors that may occur when loading an image
enum MoviesLoadingError: Swift.Error {
    case errorReceivingData
}
