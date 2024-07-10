//
//  AppConfig.swift
//  Cinetopia
//
//  Created by Bruno Moura on 05/07/24.
//

import Foundation

final class AppConfig {
    static let currentDevelopmentStatus: DevelopmentStatus = .production
    
    static func movieService() -> MovieService {
        print("Development Status:", currentDevelopmentStatus)
        switch currentDevelopmentStatus {
        case .development:
            return MockServiceManager()
        case .production:
            return TMDBServiceManager()
        }
    }
}
