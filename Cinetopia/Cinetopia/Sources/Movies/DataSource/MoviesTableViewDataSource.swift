//
//  MoviesTableViewDataSource.swift
//  Cinetopia
//
//  Created by Bruno Moura on 05/08/24.
//

import Foundation
import UIKit

final class MoviesTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var content: [Movie] = []
    weak var delegate: MovieTableViewCellProtocol?
    
    var didClickEvent: ((_ indexPath: IndexPath) -> Void)?
    var didScrollNearEnd: (() -> Void)?
    var didScrollHideKeyboard: (() -> Void)?
    
    func reloadTableView(with content: [Movie]) {
        self.content = content
    }
    
    func updateRow(id: Int) {
        guard let index = content.firstIndex(where: { $0.id == id }) else { return }
        content[index].toggleFavoriteMovieStatus()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = content[indexPath.row]
        cell.delegate(delegate: delegate)
        cell.configureCell(movie: movie)
        return cell
    }
}

extension MoviesTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didClickEvent?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= content.count - 5 {
            didScrollNearEnd?()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        didScrollHideKeyboard?()
    }
}
