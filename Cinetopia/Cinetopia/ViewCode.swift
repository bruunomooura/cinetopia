//
//  ViewCode.swift
//  Cinetopia
//
//  Created by Bruno Moura on 19/06/24.
//

import Foundation

protocol ViewCode {
    func addSubViews()
    func setupConstraints()
    func setupStyle()
}

extension ViewCode {
    func setup() {
        addSubViews()
        setupConstraints()
        setupStyle()
    }
}
