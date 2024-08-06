//
//  MoviesTableViewDataSource.swift
//  Cinetopia
//
//  Created by Bruno Moura on 05/08/24.
//

import Foundation
import UIKit

final class MoviesTableViewDataSource: NSObject, UITableViewDataSource {
    
    private weak var viewController: MoviesVC?
    
    init(viewController: MoviesVC) {
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewController?.viewModel else { return 0 }
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell,
              let movie = viewController?.viewModel.loadCurrentMovie(indexPath: indexPath) else { return UITableViewCell() }
        cell.delegate(delegate: viewController)
        cell.configureCell(movie: movie)
        return cell
    }
}
