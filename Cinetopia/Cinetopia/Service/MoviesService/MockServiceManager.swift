//
//  MockServiceManager.swift
//  Cinetopia
//
//  Created by Bruno Moura on 05/07/24.
//

import Foundation

final class MockServiceManager: MovieServiceProtocol {
    private let decoderService: JSONDecoderService
    
    init(decoderService: JSONDecoderService = JSONDecoderService()) {
        self.decoderService = decoderService
    }
    
    func fetchPopularMovies(language: String, page: Int, completion: @escaping (Result<MovieResponse, any Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: JSONFile.moviesData.rawValue, withExtension: JSONFile.json.rawValue) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let movies: MovieResponse = try decoderService.decode(MovieResponse.self, from: data)
            completion(.success(movies))
        } catch {
            print("Error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
