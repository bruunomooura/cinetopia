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
    private var collectionViewDataSource: FavoriteMoviesCollectionViewDataSource?
    
    deinit {
        print(Self.self, "- Deallocated")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupCollectionView()
        setupDataSourceCallbacks()
        setupTabBarAppearance()
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadDataMovies()
    }
    
    override func loadView() {
        self.screen = FavoriteMoviesScreen()
        view = screen
    }
    
    // MARK: - TabBar Setup
    /// Configures the appearance of the tab bar to ensure it has a consistent background color.
    private func setupTabBarAppearance() {
        guard let tabBarController = tabBarController else { return }
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBarBackground
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    // MARK: - ViewModel Setup
    /// Sets the delegate for the ViewModel and triggers the initial data load.
    private func setupViewModel() {
        viewModel.delegate(delegate: self)
        viewModel.loadDataMovies()
    }
    
    // MARK: - CollectionView Setup
    /// Initializes and configures the CollectionView's DataSource and connects it to the screen.
    private func setupCollectionView() {
        collectionViewDataSource = FavoriteMoviesCollectionViewDataSource()
        collectionViewDataSource?.delegate = self
        guard let dataSource = collectionViewDataSource else { return }
        screen?.setupCollectionView(dataSource)
    }
    
    // MARK: - DataSource Callbacks
    /// Sets up the callback for when the collection view is scrolled to trigger navigation bar appearance changes.
    private func setupDataSourceCallbacks() {
        guard let dataSource = collectionViewDataSource else {
            print("collectionViewDataSource inválido")
            return }
        
        dataSource.didScroll = { [weak self] hiddenTitle in
            self?.toggleNavBarAppearance(forHiddenTitle: hiddenTitle)
        }
    }
    
    // MARK: - Navigation Bar Appearance
    /// Toggles the navigation bar's appearance when the collection view is scrolled.
    private func toggleNavBarAppearance(forHiddenTitle hiddenTitle: Bool) {
        guard let headerView = screen?.supplementaryView() as? FavoriteMoviesCollectionReusableView else { return }
        // Animate changes to the navigation bar appearance.
        if hiddenTitle {
            UIView.animate(withDuration: 0.3) {
                self.navigationItem.title = headerView.headerText()
                self.setupNavBarAppearance(backgroundColor: .tabBarBackground)
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navigationItem.title = nil
                self.setupNavBarAppearance()
            }
        }
    }
    
    // MARK: - Setup NavigationBar Appearance
    /// Configures the navigation bar's appearance with a custom or default background color.
    private func setupNavBarAppearance(backgroundColor: UIColor = .clear) {
        guard let navigationController = navigationController else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
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
    func updateData(content: [FavoriteMovie]) {
        collectionViewDataSource?.reloadCollectionView(with: content)
        screen?.reloadCollectionView()
        screen?.noFavorites(noFavorites: viewModel.noFavorites)
    }
}

#Preview {
    UINavigationController(rootViewController: FavoriteMoviesVC())
}
