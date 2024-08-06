//
//  MoviesTableViewDelegate.swift
//  Cinetopia
//
//  Created by Bruno Moura on 05/08/24.
//

import Foundation
import UIKit

final class MoviesTableViewDelegate: NSObject, UITableViewDelegate {
    
    private weak var viewController: MoviesVC?
    
    init(viewController: MoviesVC) {
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movie = viewController?.viewModel.loadCurrentMovie(indexPath: indexPath) else { return }
        viewController?.navigation(movie: movie)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewController?.viewModel else { return 100 }
        return viewModel.heightForRow()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewController?.viewModel else { return }
        if indexPath.row >= viewModel.limitIndexForDownloadingAdditionalData && !viewModel.isLoading {
            viewModel.additionalLoadData()
        }
    }
}
