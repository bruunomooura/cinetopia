//
//  TabBarController.swift
//  Cinetopia
//
//  Created by Bruno Moura on 10/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }
    
    func setupTabBarController() {
        let moviesVC: MoviesVC = MoviesVC()
        let favoriteMoviesVC: MovieDetailsVC = MovieDetailsVC(viewModel: MovieDetailsViewModel(movie:
                .init(id: 1022789,
                      synopsis: "\"Divertida Mente 2\", da Disney e da Pixar, retorna à mente da adolescente Riley, e o faz no momento em que a sala de comando está passando por uma demolição repentina para dar lugar a algo totalmente inesperado: novas emoções! Alegria, Tristeza, Raiva, Medo e Nojinho não sabem bem como reagir quando Ansiedade aparece, e tudo indica que ela não está sozinha.",
                      imagePath: "https://image.tmdb.org/t/p/w185/9h2KgGXSmWigNTn3kQdEFFngj9i.jpg", releaseDate: "2024-06-11",
                      title: "Divertida Mente 2",
                      voteAverage: 7.701)))
        
        let viewControllerList = [moviesVC, favoriteMoviesVC]
        self.setViewControllers(viewControllerList.map { UINavigationController(rootViewController: $0) },
                                animated: false)
        self.tabBar.backgroundColor = .tabBarBackground
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .buttonBackground
        self.tabBar.unselectedItemTintColor = .lightGray
        
        guard let items = tabBar.items else { return }
        items[0].title = "Filmes"
        items[0].image = UIImage(systemName: "play.square")
        
        items[1].title = "Favoritos"
        items[1].image = UIImage(systemName: "heart.square")
    }
}
