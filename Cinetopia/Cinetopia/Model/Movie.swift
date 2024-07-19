//
//  Movie.swift
//  Cinetopia
//
//  Created by Bruno Moura on 21/06/24.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable, Equatable, Hashable {
    let id: Int
    let synopsis: String
    let popularity: Double
    var imagePath: String
    let releaseDate: String
    let title: String
    let voteAverage: Double
    private(set) var favoriteMovie: Bool? = .init()
    
    enum CodingKeys: String, CodingKey {
        case id
        case synopsis = "overview"
        case popularity
        case imagePath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
    
    // Computed property to get the Brazilian date format
    var formattedReleaseDate: String {
        return releaseDate.toBrazilianDateFormat()
    }
    
    // Computed property to generate the complete image link using baseURL, sizeImage and imagePath
    var imageURL: String {
        let imageSize = "w185"
        return APIKeys.imageBaseURL + imageSize + self.imagePath
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    public mutating func toggleFavoriteMovieStatus() {
       favoriteMovie?.toggle()
    }
}
