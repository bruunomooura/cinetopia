//
//  FavoriteMoviesCollectionReusableView.swift
//  Cinetopia
//
//  Created by Bruno Moura on 15/07/24.
//

import UIKit

class FavoriteMoviesCollectionReusableView: UICollectionReusableView {
    
    static let identifier: String = String(describing: FavoriteMoviesCollectionReusableView.self)
    
    // MARK: - UI Components
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Class methods
    func setupTitle(_ text: String) {
        headerLabel.text = text
    }
    
    public func headerText() -> String? {
        return headerLabel.text
    }
}

extension FavoriteMoviesCollectionReusableView: ViewCode {
    func addSubviews() {
        addSubview(headerLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupStyle() {
        backgroundColor = .clear
    }
}
