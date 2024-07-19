//
//  MovieTableViewCell.swift
//  Cinetopia
//
//  Created by Bruno Moura on 21/06/24.
//

import UIKit

protocol MovieTableViewCellProtocol: AnyObject {
    func didSelectedFavoriteButton(_ sender: UIButton)
}

final class MovieTableViewCell: UITableViewCell {
    
    private weak var delegate: MovieTableViewCellProtocol?
    
    static let identifier: String = String(describing: MovieTableViewCell.self)
    
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
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var movieReleaseDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white.withAlphaComponent(0.75)
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var configurationButton = UIButton.Configuration.filled()
        configurationButton.imagePadding = 8
        configurationButton.imagePlacement = .leading
        configurationButton.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        configurationButton.background.cornerRadius = 10
        configurationButton.background.strokeColor = .buttonBackground
        configurationButton.background.strokeWidth = 2
        configurationButton.baseBackgroundColor = .clear
        configurationButton.title = "Favoritar"
        
        let font = UIFont.systemFont(ofSize: 14)
        configurationButton.attributedTitle = AttributedString("Favoritar", attributes: AttributeContainer([
            .font: font, .foregroundColor: UIColor.white
        ]))
        button.configuration = configurationButton
        button.addTarget(self, action: #selector(tappedFavoriteButton), for: .touchDown)
        return button
    }()
    
    @objc
    private func tappedFavoriteButton(_ sender: UIButton) {
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
    
    public func delegate(delegate: MovieTableViewCellProtocol?) {
        self.delegate = delegate
    }
    
    public func configureCell(movie: Movie) {
        moviePosterImageView.loadImageFromURL(movie.imageURL)
        movieTitleLabel.text = movie.title
        movieReleaseDateLabel.text = "Lançamento: \(movie.formattedReleaseDate)"
        let iconImage = UIImage(systemName: movie.favoriteMovie == true ? "heart.fill" : "heart")?.withTintColor(.buttonBackground, renderingMode: .alwaysOriginal)
        favoriteButton.setImage(iconImage, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(Self.self, "- Deallocated")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension MovieTableViewCell: ViewCode {
    func addSubviews() {
        addSubview(moviePosterImageView)
        addSubview(movieTitleLabel)
        addSubview(movieReleaseDateLabel)
        contentView.addSubview(favoriteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            moviePosterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            moviePosterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            movieTitleLabel.bottomAnchor.constraint(equalTo: moviePosterImageView.centerYAnchor, constant: -20),
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 16),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            movieReleaseDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 8),
            movieReleaseDateLabel.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: movieReleaseDateLabel.bottomAnchor, constant: 8),
            favoriteButton.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor)
        ])
    }
    
    func setupStyle() {
        backgroundColor = .clear
    }
}

#Preview {
    UINavigationController(rootViewController: MoviesVC())
    //    MovieTableViewCell()
}
