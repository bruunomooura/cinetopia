//
//  HomeVC.swift
//  Cinetopia
//
//  Created by Bruno Moura on 18/06/24.
//

import UIKit

final class HomeVC: UIViewController {

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
        let tabBar: TabBarController = TabBarController()
        if let windowScene = view.window?.windowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = tabBar
                UIView.transition(with: window,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
            }
        }
    }
}

#Preview {
    UINavigationController(rootViewController: HomeVC())
}
