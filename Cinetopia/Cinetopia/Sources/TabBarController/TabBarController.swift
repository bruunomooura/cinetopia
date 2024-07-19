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
        let favoriteMoviesVC: FavoriteMoviesVC = FavoriteMoviesVC()
        
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
