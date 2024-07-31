//
//  FavoriteMoviesVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 11/07/24.
//

import UIKit

class FavoriteMoviesVC: UIViewController {
    
    var viewModel: FavoriteMoviesViewModel = FavoriteMoviesViewModel()
    var screen: FavoriteMoviesScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.setupCollectionView(delegate: self, dataSource: self)
        viewModel.delegate(delegate: self)
        navigationItem.setHidesBackButton(true, animated: true)
        // Configure navigation bar appearance
        configureNavigationBarAppearance()
        
        // Configure tab bar appearance
        configureTabBarAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateData()
    }
    
    override func loadView() {
        self.screen = FavoriteMoviesScreen()
        view = screen
    }
    
    private func configureNavigationBarAppearance(backgroundColor: UIColor = .clear) {
        guard let navigationController = navigationController else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureTabBarAppearance() {
        guard let tabBarController = tabBarController else { return }
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBarBackground
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

extension FavoriteMoviesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier, for: indexPath) as? FavoriteMoviesCollectionViewCell else { return UICollectionViewCell() }
        let movie = viewModel.loadCurrentMovie(indexPath: indexPath)
        cell.delegate(delegate: self)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = screen?.supplementaryView() as? FavoriteMoviesCollectionReusableView else { return }
        
        let yOffset = scrollView.contentOffset.y
        
        if yOffset > 35 {
            UIView.animate(withDuration: 0.3) {
                self.navigationItem.title = headerView.headerText()
                self.configureNavigationBarAppearance(backgroundColor: .tabBarBackground)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navigationItem.title = nil
                self.configureNavigationBarAppearance()
            }
        }
    }
}

extension FavoriteMoviesVC: FavoriteMoviesCollectionViewCellProtocol {
    func didSelectedFavoriteButton(_ sender: UIButton) {
        guard let cell = sender.superview as? FavoriteMoviesCollectionViewCell else { return }
        
        guard let indexPath = screen?.indexPath(for: cell) else { return }
        let movie = viewModel.loadCurrentMovie(indexPath: indexPath)
        viewModel.removeFavoriteMovie(id: movie.id)
    }
}

extension FavoriteMoviesVC: FavoriteMoviesViewModelProtocol {
    func updateData() {
        screen?.reloadCollectionView()
        screen?.noFavorites(noFavorites: viewModel.noFavorites)
    }
}

#Preview {
    UINavigationController(rootViewController: FavoriteMoviesVC())
}
