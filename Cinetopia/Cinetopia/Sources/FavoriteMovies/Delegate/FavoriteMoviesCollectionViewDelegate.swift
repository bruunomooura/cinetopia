//
//  FavoriteMoviesCollectionViewDelegate.swift
//  Cinetopia
//
//  Created by Bruno Moura on 06/08/24.
//

import Foundation
import UIKit

final class FavoriteMoviesCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    private weak var viewController: FavoriteMoviesVC?
    
    init(viewController: FavoriteMoviesVC) {
        self.viewController = viewController
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = viewController?.screen?.supplementaryView() as? FavoriteMoviesCollectionReusableView else { return }
        
        let yOffset = scrollView.contentOffset.y
        
        if yOffset > 35 {
            UIView.animate(withDuration: 0.3) {
                self.viewController?.navigationItem.title = headerView.headerText()
                self.configureNavigationBarAppearance(backgroundColor: .tabBarBackground)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.viewController?.navigationItem.title = nil
                self.configureNavigationBarAppearance()
            }
        }
    }
    
    /// Configure navigation bar appearance
    private func configureNavigationBarAppearance(backgroundColor: UIColor = .clear) {
        guard let navigationController = viewController?.navigationController else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
}
