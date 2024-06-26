//
//  HomeVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 18/06/24.
//

import UIKit

class HomeVC: UIViewController {

    var screen: HomeScreen?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.delegate(delegate: self)
    }
    
    override func loadView() {
        self.screen = HomeScreen()
        view = screen
    }
}

extension HomeVC: HomeScreenProtocol {
    func navigation() {
        navigationController?.pushViewController(MoviesVC(), animated: true)
    }
}

#Preview {
    UINavigationController(rootViewController: HomeVC())
}
