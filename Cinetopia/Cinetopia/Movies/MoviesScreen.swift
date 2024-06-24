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
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Pesquisar"
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.barTintColor = .white
        searchBar.keyboardType = .alphabet
        searchBar.inputAccessoryView = addDoneButtonOnKeyboard
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var noResultsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nenhum filme \nencontrado"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    private lazy var addDoneButtonOnKeyboard: UIToolbar = {
        let doneToolbar = UIToolbar()
        doneToolbar.barStyle = .default
        doneToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Concluído", style: .done, target: self, action: #selector(doneButtonAction))
        ]
        doneToolbar.tintColor = .black
        doneToolbar.sizeToFit()
        return doneToolbar
    }()
    
    @objc private func doneButtonAction() {
        searchBar.resignFirstResponder()
    }
    
    public func setupTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    public func setupSearchBar(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    public func reloadTableView() {
        tableView.reloadData()
    }
    
    public func noResults(noResults: Bool) {
        tableView.isHidden = noResults
        noResultsLabel.isHidden = !noResults
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
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(noResultsLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noResultsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            noResultsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noResultsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            noResultsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .background
    }
}

#Preview {
    UINavigationController(rootViewController: MoviesVC())
}
