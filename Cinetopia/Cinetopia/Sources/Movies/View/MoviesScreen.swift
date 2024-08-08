//
//  MoviesScreen.swift
//  Cinetopia
//
//  Created by Bruno Moura on 20/06/24.
//

import UIKit

final class MoviesScreen: UIView {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "movies.searchBar.placeholder".localized
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.barTintColor = .white
        searchBar.keyboardType = .alphabet
        searchBar.inputAccessoryView = addDoneButtonOnKeyboard
        
        // Configure the placeholder color
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray // Cor do placeholder
        ]
        let attributedPlaceholder = NSAttributedString(string: searchBar.placeholder ?? "", attributes: placeholderAttributes)
        searchBar.searchTextField.attributedPlaceholder = attributedPlaceholder
        
        // Configure the color of the typed text
        searchBar.searchTextField.defaultTextAttributes = [
            .foregroundColor: UIColor.black, // Cor do texto digitado
            .font: UIFont.systemFont(ofSize: 16) // Fonte do texto
        ]
        
        // Configure the color of the magnifying glass image and the search bar clear button
        if let textField = searchBar.value(forKey: "searchField") as? UITextField,
           let leftView = textField.leftView as? UIImageView,
           let clearButton = textField.value(forKey: "clearButton") as? UIButton {
            
            // Configure the color of the searchBar magnifying glass
            leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
            leftView.tintColor = .gray
            
            // Configure the color of the clear button
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = .gray
        }
        
        return searchBar
    }()
    
    private lazy var addDoneButtonOnKeyboard: UIToolbar = {
        let doneToolbar = UIToolbar()
        doneToolbar.barStyle = .default
        doneToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "movies.toolBar.button.title".localized, style: .done, target: self, action: #selector(doneButtonAction))
        ]
        
        doneToolbar.tintColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .light ? .black : .white
        }
        doneToolbar.sizeToFit()
        return doneToolbar
    }()
    
    @objc private func doneButtonAction() {
        searchBar.resignFirstResponder()
    }
    
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
        label.text = "movies.title.noResults".localized
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
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
    
    public func reloadRows(_ indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    public func insertRowsTableView(indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .none)
    }
    
    public func noResults(noResults: Bool) {
        tableView.isHidden = noResults
        noResultsLabel.isHidden = !noResults
    }
    
    public func indexPath(for cell: UITableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
    
    public func hideKeyboard() {
        searchBar.resignFirstResponder()
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

extension MoviesScreen: ViewCode {
    func addSubviews() {
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
