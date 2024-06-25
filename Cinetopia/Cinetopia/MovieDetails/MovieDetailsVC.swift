//
//  MovieDetailsVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 24/06/24.
//

import UIKit

class MovieDetailsVC: UIViewController {

    var viewModel: MovieDetailsViewModel
    var screen: MovieDetailsScreen?
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.configData(movie: viewModel.movie)
    }
    
    override func loadView() {
        self.screen = MovieDetailsScreen()
        view = screen
    }
    
    

}

#Preview {
    UINavigationController(rootViewController: MovieDetailsVC(viewModel: .init(movie: movies[0])))
}
