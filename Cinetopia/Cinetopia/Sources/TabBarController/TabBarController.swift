//
//  TabBarController.swift
//  Cinetopia
//
//  Created by Bruno Moura on 10/07/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
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
        items[0].title = "tabBar.titleOne.movies".localized
        items[0].image = UIImage(systemName: SystemImage.playSquare.rawValue)
        
        items[1].title = "tabBar.titleTwo.favorites".localized
        items[1].image = UIImage(systemName: SystemImage.heartSquare.rawValue)
    }
}
