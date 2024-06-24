//
//  MoviesVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import UIKit

class MoviesVC: UIViewController {

    var viewModel: MoviesViewModel = MoviesViewModel()
    var screen: MoviesScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        screen?.delegate(delegate: self)
        screen?.setupTableView(delegate: self, dataSource: self)
        screen?.setupSearchBar(delegate: self)
        viewModel.delegate = self
    }
    
    override func loadView() {
        self.screen = MoviesScreen()
        view = screen
    }
    
    private func setupNavigationBar() {
        title = "Filmes populares"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationItem.setHidesBackButton(true, animated: true)
    }
}

extension MoviesVC: MoviesScreenProtocol {
//    func navigation() {
//        
//    }
}

extension MoviesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.loadCurrentMovie(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell
        cell?.configureCell(movie: movie)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow()
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

extension MoviesVC: MoviesViewModelProtocol {
    func searchText() {
        screen?.reloadTableView()
        screen?.noResults(noResults: viewModel.noResults)
    }
}

#Preview {
    UINavigationController(rootViewController: MoviesVC())
}
