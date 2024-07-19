//
//  FavoriteMoviesCollectionViewCell.swift
//  Cinetopia
//
//  Created by Bruno Moura on 11/07/24.
//

import UIKit

protocol FavoriteMoviesCollectionViewCellProtocol: AnyObject {
    func didSelectedFavoriteButton(_ sender: UIButton)
}

final class FavoriteMoviesCollectionViewCell: UICollectionViewCell {
    
    private weak var delegate: FavoriteMoviesCollectionViewCellProtocol?
    
    static let identifier: String = String(describing: FavoriteMoviesCollectionViewCell.self)
    
    private lazy var moviePosterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var movieTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var configurationButton = UIButton.Configuration.filled()
        configurationButton.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        configurationButton.background.cornerRadius = 10
        configurationButton.background.strokeColor = .buttonBackground
        configurationButton.background.strokeWidth = 1
        configurationButton.baseForegroundColor = .buttonBackground
        configurationButton.baseBackgroundColor = .clear
        button.configuration = configurationButton
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchDown)
        
        return button
    }()
    
    @objc
    private func didTapFavoriteButton(_ sender: UIButton) {
        scaleDown(sender)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.scaleUp(sender)
            self.delegate?.didSelectedFavoriteButton(sender)
        }
    }
    
    private func scaleDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.alpha = 0.5
        })
    }
    
    private func scaleUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform.identity
            sender.alpha = 1.0
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func delegate(delegate: FavoriteMoviesCollectionViewCellProtocol?) {
        self.delegate = delegate
    }
    
    public func configureCell(movie: Movie) {
        moviePosterImageView.loadImageFromURL(movie.imageURL)
        movieTitleLabel.text = movie.title
        let iconImage = UIImage(systemName: movie.favoriteMovie == true ? "heart.fill" : "heart")
        favoriteButton.setImage(iconImage, for: .normal)
    }
}

extension FavoriteMoviesCollectionViewCell: ViewCode {
    func addSubviews() {
        addSubview(moviePosterImageView)
        addSubview(movieTitleLabel)
        addSubview(favoriteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: topAnchor),
            moviePosterImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 119),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 89),
            
            movieTitleLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 8),
            movieTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieTitleLabel.bottomAnchor.constraint(equalTo: favoriteButton.topAnchor),
            
            favoriteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 35),
            favoriteButton.widthAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .clear
    }
}

#Preview {
    UINavigationController(rootViewController: FavoriteMoviesVC())
}
