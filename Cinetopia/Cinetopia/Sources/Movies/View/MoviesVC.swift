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
    private var tableViewDataSource: MoviesTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewModel()
        setupSearchBar()
        setupTableView()
        setupDataSourceCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.filterMovies()
    }
    
    override func loadView() {
        self.screen = MoviesScreen()
        view = screen
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
    
    // MARK: - Navigation Bar Setup
    /// Configures the navigation bar appearance and title.
    private func setupNavigationBar() {
        title = "tabBar.titleOne.movies".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    // MARK: - ViewModel Setup
    /// Sets the delegate for the ViewModel and triggers movie data loading.
    private func setupViewModel() {
        viewModel.delegate(delegate: self)
        viewModel.loadDataMovies()
    }
    
    // MARK: - Search Bar Setup
    /// Configures the Search Bar and assigns the delegate.
    private func setupSearchBar() {
        screen?.setupSearchBar(delegate: self)
    }
    
    // MARK: - TableView Setup
    /// Initializes and configures the TableView DataSource and connects it to the screen.
    private func setupTableView() {
        tableViewDataSource = MoviesTableViewDataSource()
        tableViewDataSource?.delegate = self
        guard let dataSource = tableViewDataSource else { return }
        screen?.setupTableView(dataSource)
    }
    
    // MARK: - DataSource Callbacks Setup
    /// Defines the DataSource callbacks for handling scroll events and item selection.
    private func setupDataSourceCallbacks() {
        guard let dataSource = tableViewDataSource else { return }
        
        // Callback for loading more data when nearing the end of the list
        dataSource.didScrollNearEnd = { [weak self] in
            self?.viewModel.additionalLoadData()
        }
        
        // Callback for handling movie item selection
        dataSource.didClickEvent = { [weak self] indexPath in
            if let movie = self?.viewModel.loadCurrentMovie(indexPath: indexPath) {
                self?.navigation(movie: movie)
            }
        }
        
        // Callback to hide the keyboard during scroll events
        dataSource.didScrollHideKeyboard = { [weak self] in
            self?.screen?.hideKeyboard()
        }
    }
    
    // MARK: - Navigation
    /// Pushes the `MovieDetailsVC` onto the navigation stack with the given movie's details.
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
        tableViewDataSource?.updateRow(id: movie.id)
        screen?.reloadRows([indexPath])
    }
}

extension MoviesVC: MoviesViewModelProtocol {
    func searchText(content: [Movie]) {
        tableViewDataSource?.reloadTableView(with: content)
        screen?.reloadTableView()
        screen?.noResults(noResults: viewModel.noResults)
    }
    
    func updateData(content: [Movie]) {
        tableViewDataSource?.reloadTableView(with: content)
        screen?.reloadTableView()
        screen?.noResults(noResults: viewModel.noResults)
    }
    
    func insertRows(content: [Movie], _ newsIndexPaths: [IndexPath]) {
        tableViewDataSource?.reloadTableView(with: content)
        screen?.insertRowsTableView(indexPaths: newsIndexPaths)
    }
}

#Preview {
    UINavigationController(rootViewController: MoviesVC())
}
