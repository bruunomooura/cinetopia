//
//  MoviesScreen.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import UIKit

protocol MoviesScreenProtocol: AnyObject {
//    func navigation()
}

class MoviesScreen: UIView {

    private weak var delegate: MoviesScreenProtocol?
    
    public func delegate(delegate: MoviesScreenProtocol?) {
        self.delegate = delegate
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

}

extension MoviesScreen: ViewCode {
    func addSubViews() {
//        <#code#>
    }
    
    func setupConstraints() {
//        <#code#>
    }
    
    func setupStyle() {
        backgroundColor = .background
//        title = "Filmes populares"
    }
}
