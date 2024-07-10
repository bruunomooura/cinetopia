//
//  MovieDetailsScreen.swift
//  Cinetopia
//
//  Created by Bruno Moura on 24/06/24.
//

import UIKit

final class MovieDetailsScreen: UIView {

    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var moviePosterImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var movieRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var movieSynopsisLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    func configData(movie: Movie) {
        movieTitleLabel.text = movie.title
        moviePosterImageView.loadImageFromURL(movie.imageURL)
        movieRateLabel.text = "Classificação dos usuários: \(movie.voteAverage)"
        movieSynopsisLabel.text = movie.synopsis
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieDetailsScreen: ViewCode {
    func addSubViews() {
        addSubview(movieStackView)
        movieStackView.addArrangedSubview(movieTitleLabel)
        movieStackView.addArrangedSubview(moviePosterImageView)
        movieStackView.addArrangedSubview(movieRateLabel)
        addSubview(movieSynopsisLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            movieStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            movieStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            movieStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            moviePosterImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 235),
            moviePosterImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 178),
            
            movieSynopsisLabel.topAnchor.constraint(equalTo: movieStackView.bottomAnchor, constant: 40),
            movieSynopsisLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            movieSynopsisLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .background
    }
}

#Preview {
    UINavigationController(rootViewController: MovieDetailsVC(viewModel: MovieDetailsViewModel(movie:
            .init(id: 1022789,
                  synopsis: "\"Divertida Mente 2\", da Disney e da Pixar, retorna à mente da adolescente Riley, e o faz no momento em que a sala de comando está passando por uma demolição repentina para dar lugar a algo totalmente inesperado: novas emoções! Alegria, Tristeza, Raiva, Medo e Nojinho não sabem bem como reagir quando Ansiedade aparece, e tudo indica que ela não está sozinha.",
                  imagePath: "https://image.tmdb.org/t/p/w185/9h2KgGXSmWigNTn3kQdEFFngj9i.jpg", releaseDate: "2024-06-11",
                  title: "Divertida Mente 2",
                  voteAverage: 7.701))))
}
