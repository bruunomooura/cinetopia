//
//  MovieDetailsVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 24/06/24.
//

import UIKit

final class MovieDetailsVC: UIViewController {

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
    UINavigationController(rootViewController: MovieDetailsVC(viewModel: MovieDetailsViewModel(movie:
            .init(id: 1022789,
                  synopsis: "\"Divertida Mente 2\", da Disney e da Pixar, retorna à mente da adolescente Riley, e o faz no momento em que a sala de comando está passando por uma demolição repentina para dar lugar a algo totalmente inesperado: novas emoções! Alegria, Tristeza, Raiva, Medo e Nojinho não sabem bem como reagir quando Ansiedade aparece, e tudo indica que ela não está sozinha.", popularity: 5389.964,
                  imagePath: "https://image.tmdb.org/t/p/w185/9h2KgGXSmWigNTn3kQdEFFngj9i.jpg", releaseDate: "2024-06-11",
                  title: "Divertida Mente 2",
                  voteAverage: 7.701))))
}
