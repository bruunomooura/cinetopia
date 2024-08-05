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
    
    func fetchPopularMovies(language: String, page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular") else { return }
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
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
        
        dataTask = session.dataTask(with: request) { [ weak self ] data, response, error in
            guard let self = self else { return }
            if let error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data else {
                print("No data received")
                completion(.failure(MoviesLoadingError.errorReceivingData))
                return }
            
            do {                
                let movies = try self.decoderService.decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(movies))
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}

// Enum that represents the possible errors that may occur when loading an image
enum MoviesLoadingError: Swift.Error {
    case errorReceivingData
}
