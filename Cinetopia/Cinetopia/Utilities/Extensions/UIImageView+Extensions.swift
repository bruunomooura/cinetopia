//
//  UIImageView+Extensions.swift
//  Cinetopia
//
//  Created by Bruno Moura on 28/06/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromURL(_ urlString: String, completion: ((Result<UIImage, Error>) -> Void)? = nil) {
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            completion?(.failure(ImageLoadingError.unknownError))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Error converting data to image.")
                DispatchQueue.main.async {
                    completion?(.failure(ImageLoadingError.unknownError))
                }
                return
            }
                        
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.image = image
                self.contentMode = .scaleAspectFill
                completion?(.success(image))
            }
        }
        task.resume()
    }
}

// Enum that represents the possible errors that may occur when loading an image
enum ImageLoadingError: Swift.Error {
    case unknownError
}
