//
//  HomeScreen.swift
//  Cinetopia
//
//  Created by Bruno Moura on 19/06/24.
//

import UIKit

protocol HomeScreenProtocol: AnyObject {
    func navigation()
}

final class HomeScreen: UIView {
    
    private weak var delegate: HomeScreenProtocol?
    
    public func delegate(delegate: HomeScreenProtocol?) {
        self.delegate = delegate
    }
    
    private lazy var logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = UIImage.logoCinetopia
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var coupleImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = UIImage.couple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "O lugar ideal para buscar, salvar e organizar seus filmes favoritos!"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var welcomeButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Quero começar!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.background, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 34
        button.backgroundColor = .buttonBackground
        button.addTarget(self, action: #selector(tappedWelcomeButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc 
    private func tappedWelcomeButton(_ sender: UIButton) {
        print("tapped button")
        delegate?.navigation()
    }
    
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeScreen: ViewCode {
    func addSubViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(coupleImageView)
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(welcomeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -64),
            welcomeLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            welcomeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),

            welcomeButton.heightAnchor.constraint(equalToConstant: 68),
            welcomeButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 64),
            welcomeButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -64),
        ])
    }
    
    func setupStyle() {
        backgroundColor = UIColor.background
    }
}

#Preview {
    UINavigationController(rootViewController: HomeVC())
}
