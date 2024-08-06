//
//  FavoriteMoviesVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 11/07/24.
//

import UIKit

final class FavoriteMoviesVC: UIViewController {
    
    var viewModel: FavoriteMoviesViewModel = FavoriteMoviesViewModel()
    var screen: FavoriteMoviesScreen?
    private var collectionViewDelegate: FavoriteMoviesCollectionViewDelegate?
    private var collectionViewDataSource: FavoriteMoviesCollectionViewDataSource?
    
    deinit {
        print(Self.self, "- Deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDelegate = FavoriteMoviesCollectionViewDelegate(viewController: self)
        collectionViewDataSource = FavoriteMoviesCollectionViewDataSource(viewController: self)
        guard let delegate = collectionViewDelegate,
              let dataSource = collectionViewDataSource else { return }
        screen?.setupCollectionView(delegate: delegate, dataSource: dataSource)
        viewModel.delegate(delegate: self)
        navigationItem.setHidesBackButton(true, animated: true)

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
