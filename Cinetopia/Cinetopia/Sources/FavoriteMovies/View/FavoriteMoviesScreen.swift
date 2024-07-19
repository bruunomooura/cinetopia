//
//  FavoriteMoviesScreen.swift
//  Cinetopia
//
//  Created by Bruno Moura on 11/07/24.
//

import Foundation
import UIKit

final class FavoriteMoviesScreen: UIView {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let numberOfColumns: CGFloat = 2
        let spacingBetweenItems: CGFloat = 26
        let leftAndRightSpacing: CGFloat = 16
        let totalWidthSpacing = (2 * leftAndRightSpacing) + spacingBetweenItems
        let itemWidth = (UIScreen.main.bounds.width - totalWidthSpacing) / numberOfColumns
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.32)
        layout.sectionInset = UIEdgeInsets(top: 40,
                                           left: 16,
                                           bottom: 16,
                                           right: 16)
        layout.minimumInteritemSpacing = spacingBetweenItems
        layout.minimumLineSpacing = spacingBetweenItems
        
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FavoriteMoviesCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavoriteMoviesCollectionViewCell.identifier)
        collectionView.register(FavoriteMoviesCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoriteMoviesCollectionReusableView.identifier)
        return collectionView
    }()
    
    private lazy var noFavoriteMoviesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Você ainda não favoritou nenhum filme"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    public func setupCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    public func noFavorites(noFavorites: Bool) {
        collectionView.isHidden = noFavorites
        noFavoriteMoviesLabel.isHidden = !noFavorites
    }
    
    public func indexPath(for cell: UICollectionViewCell) -> IndexPath? {
        return collectionView.indexPath(for: cell)
    }
    
    public func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    public func supplementaryView() -> UICollectionReusableView? {
        return collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
}

extension FavoriteMoviesScreen: ViewCode {
    func addSubviews() {
        addSubview(collectionView)
        addSubview(noFavoriteMoviesLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noFavoriteMoviesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            noFavoriteMoviesLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noFavoriteMoviesLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .background
    }
}

#Preview {
    UINavigationController(rootViewController: FavoriteMoviesVC())
}
