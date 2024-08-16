//
//  FavoriteMoviesCollectionViewDataSource.swift
//  Cinetopia
//
//  Created by Bruno Moura on 06/08/24.
//

import Foundation
import UIKit

final class FavoriteMoviesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private var content: [FavoriteMovie] = []
    weak var delegate: FavoriteMoviesCollectionViewCellProtocol?
    
    public var didScroll: ((_ hiddenTitle: Bool) -> Void)?
    
    public func reloadCollectionView(with content: [FavoriteMovie]) {
        self.content = content
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier, for: indexPath) as? FavoriteMoviesCollectionViewCell else { return UICollectionViewCell() }
        let movie = content[indexPath.row]
        cell.delegate(delegate: delegate)
        cell.configureCell(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteMoviesCollectionReusableView.identifier, for: indexPath) as? FavoriteMoviesCollectionReusableView else {
                fatalError("error to create collectionview header")
            }
            headerView.setupTitle("favoriteMovies.collectionView.title".localized)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}

extension FavoriteMoviesCollectionViewDataSource: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset > 35 {
            didScroll?(true)
        } else {
            didScroll?(false)
        }
    }
}
