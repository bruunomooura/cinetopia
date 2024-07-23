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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        screen?.setupTableView(delegate: self, dataSource: self)
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
        title = "Filmes populares"
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

extension MoviesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = viewModel.loadCurrentMovie(indexPath: indexPath)
        cell.delegate(delegate: self)
        cell.configureCell(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = viewModel.loadCurrentMovie(indexPath: indexPath)
        navigation(movie: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.limitIndexForDownloadingAdditionalData && !viewModel.isLoading {
            viewModel.additionalLoadData()
        }
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
        viewModel.toggleFavoriteMovie(id: movie.id)
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
