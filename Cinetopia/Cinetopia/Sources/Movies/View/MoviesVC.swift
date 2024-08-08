//
//  MoviesVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import UIKit

final class MoviesVC: UIViewController {
    
    var viewModel: MoviesViewModel = MoviesViewModel()
    var screen: MoviesScreen?
    private var tableViewDelegate: MoviesTableViewDelegate?
    private var tableViewDataSource: MoviesTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableViewDelegate = MoviesTableViewDelegate(viewController: self)
        tableViewDataSource = MoviesTableViewDataSource(viewController: self)
        guard let delegate = tableViewDelegate,
              let dataSource = tableViewDataSource else { return }
        screen?.setupTableView(delegate: delegate, dataSource: dataSource)
        screen?.setupSearchBar(delegate: self)
        viewModel.delegate(delegate: self)
        viewModel.loadDataMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.filterMovies()
        updateData()
    }
    
    override func loadView() {
        self.screen = MoviesScreen()
        view = screen
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
    
    private func setupNavigationBar() {
        title = "tabBar.titleOne.movies".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func navigation(movie: Movie) {
        let movieDetailsViewModel = MovieDetailsViewModel(movie: movie)
        navigationController?.pushViewController(MovieDetailsVC(viewModel: movieDetailsViewModel), animated: true)
    }
}

extension MoviesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MoviesVC: MovieTableViewCellProtocol {
    func didSelectedFavoriteButton(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? MovieTableViewCell else { return }
        guard let indexPath = screen?.indexPath(for: cell) else { return }
        let movie = viewModel.loadCurrentMovie(indexPath: indexPath)
        viewModel.toggleFavoriteMovie(movie: movie)
        screen?.reloadRows([indexPath])
    }
}

extension MoviesVC: MoviesViewModelProtocol {
    func searchText() {
        screen?.reloadTableView()
        screen?.noResults(noResults: viewModel.noResults)
    }
    
    func updateData() {
        screen?.reloadTableView()
        screen?.noResults(noResults: viewModel.noResults)
    }
    
    func insertRows(_ newsIndexPaths: [IndexPath]) {
        screen?.insertRowsTableView(indexPaths: newsIndexPaths)
    }
}

#Preview {
    UINavigationController(rootViewController: MoviesVC())
}
