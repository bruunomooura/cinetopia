//
//  ViewCode.swift
//  Cinetopia
//
//  Created by Bruno Moura on 19/06/24.
//

import Foundation

protocol ViewCode {
    func addSubviews()
    func setupConstraints()
    func setupStyle()
}

extension ViewCode {
    func setup() {
        addSubviews()
        setupConstraints()
        setupStyle()
    }
}
