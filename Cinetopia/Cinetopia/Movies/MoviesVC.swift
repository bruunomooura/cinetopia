//
//  MoviesVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import UIKit

class MoviesVC: UIViewController {

    var screen: MoviesScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        screen?.delegate(delegate: self)
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

#Preview {
    UINavigationController(rootViewController: HomeVC())
}
