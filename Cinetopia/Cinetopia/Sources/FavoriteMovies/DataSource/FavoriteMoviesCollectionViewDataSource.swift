//
//  FavoriteMoviesCollectionViewDataSource.swift
//  Cinetopia
//
//  Created by Bruno Moura on 06/08/24.
//

import Foundation
import UIKit

final class FavoriteMoviesCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private weak var viewController: FavoriteMoviesVC?
    
    init(viewController: FavoriteMoviesVC) {
        self.viewController = viewController
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewController?.viewModel else { return 0 }
        return viewModel.numberOfRowsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier, for: indexPath) as? FavoriteMoviesCollectionViewCell,
              let movie = viewController?.viewModel.loadCurrentMovie(indexPath: indexPath) else { return UICollectionViewCell() }
        cell.delegate(delegate: viewController)
        cell.configureCell(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteMoviesCollectionReusableView.identifier, for: indexPath) as? FavoriteMoviesCollectionReusableView else {
                fatalError("error to create collectionview header")
            }
            headerView.setupTitle("Meus filmes favoritos")
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}
