//
//  TabViewController.swift
//  NeevaWebBrowser
//
//  Created by Nicholas Angelo Petelo on 10/15/21.
//

import UIKit

class TabViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .lightGray
        searchBar.barTintColor = .darkGray
        searchBar.placeholder = "Enter URL"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let websiteVC: WebsiteViewController = {
        let vc = WebsiteViewController()
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    let navigationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.backward", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))), for: .normal)
        button.tintColor = .gray
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.forward", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))), for: .normal)
        button.tintColor = .gray
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        return button
    }()
    
    let addTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))), for: .normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    let tabsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.on.square", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))), for: .normal)
        button.addTarget(self, action: #selector(didTapTabsButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBookmarksButton), for: .touchUpInside)
        return button
    }()
    
    let refreshButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))), for: .normal)
        button.tintColor = .gray
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        return button
    }()
    
    var didTapAddCompletion: ((TabViewController) -> Void)?
    var canGoBack: Bool = false {
        didSet {
            if canGoBack {
                self.backButton.isUserInteractionEnabled = true
                self.backButton.tintColor = .white
            } else {
                self.backButton.isUserInteractionEnabled = false
                self.backButton.tintColor = .gray
            }
        }
    }
    var canGoForward: Bool = false {
        didSet {
            if canGoForward {
                self.forwardButton.isUserInteractionEnabled = true
                self.forwardButton.tintColor = .white
            } else {
                self.forwardButton.isUserInteractionEnabled = false
                self.forwardButton.tintColor = .gray
            }
        }
    }
    var canRefresh: Bool = false {
        didSet {
            if canRefresh {
                self.refreshButton.isUserInteractionEnabled = true
                self.refreshButton.tintColor = .white
            } else {
                self.refreshButton.isUserInteractionEnabled = false
                self.refreshButton.tintColor = .gray
            }
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        searchBar.delegate = self
        configureViews()
        configureConstraints()
        setupCompletionHandlers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.text = websiteVC.getUrlString() == "about:blank" ? "" : websiteVC.getUrlString()
    }
    
    private func configureViews() {
        view.addSubview(searchBar)
        view.addSubview(refreshButton)
        view.addSubview(websiteVC.view)
        view.addSubview(navigationView)
        navigationView.addSubview(backButton)
        navigationView.addSubview(forwardButton)
        navigationView.addSubview(addTabButton)
        navigationView.addSubview(tabsButton)
        navigationView.addSubview(bookmarkButton)
    }
    
    private func configureConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //Search Bar constraints
        constraints.append(searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(searchBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70))
        constraints.append(searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8))
        
        //Refresh Button constraints
        constraints.append(refreshButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70))
        constraints.append(refreshButton.leadingAnchor.constraint(equalTo: searchBar.trailingAnchor))
        constraints.append(refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        //Website View constraints
        constraints.append(websiteVC.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor))
        constraints.append(websiteVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(websiteVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(websiteVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70))
        
        //Navigation View constraints
        constraints.append(navigationView.topAnchor.constraint(equalTo: websiteVC.view.bottomAnchor))
        constraints.append(navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(navigationView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        //Back Button constraints
        constraints.append(backButton.trailingAnchor.constraint(equalTo: forwardButton.leadingAnchor, constant: -40))
        constraints.append(backButton.heightAnchor.constraint(equalToConstant: 30))
        constraints.append(backButton.widthAnchor.constraint(equalToConstant: 30))
        constraints.append(backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor))
        
        //Forward Button constraints
        constraints.append(forwardButton.trailingAnchor.constraint(equalTo: addTabButton.leadingAnchor, constant: -40))
        constraints.append(forwardButton.heightAnchor.constraint(equalToConstant: 30))
        constraints.append(forwardButton.widthAnchor.constraint(equalToConstant: 30))
        constraints.append(forwardButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor))
        
        //Add Tab Button constraints
        constraints.append(addTabButton.heightAnchor.constraint(equalToConstant: 30))
        constraints.append(addTabButton.widthAnchor.constraint(equalToConstant: 30))
        constraints.append(addTabButton.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor))
        constraints.append(addTabButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor))
        
        //Tabs Button constraints
        constraints.append(tabsButton.leadingAnchor.constraint(equalTo: addTabButton.trailingAnchor, constant: 40))
        constraints.append(tabsButton.heightAnchor.constraint(equalToConstant: 30))
        constraints.append(tabsButton.widthAnchor.constraint(equalToConstant: 30))
        constraints.append(tabsButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor))
        
        //Bookmark Button constraints
        constraints.append(bookmarkButton.leadingAnchor.constraint(equalTo: tabsButton.trailingAnchor, constant: 40))
        constraints.append(bookmarkButton.heightAnchor.constraint(equalToConstant: 30))
        constraints.append(bookmarkButton.widthAnchor.constraint(equalToConstant: 30))
        constraints.append(bookmarkButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor))
        
        view.addConstraints(constraints)
    }
        
    @objc private func didTapBackButton() {
        websiteVC.goBack()
    }
    
    @objc private func didTapForwardButton() {
        websiteVC.goForward()
    }
    
    @objc private func didTapAddButton() {
        let newVC = TabViewController()
        didTapAddCompletion?(newVC)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc private func didTapTabsButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapBookmarksButton() {
        let newVC = BookmarksViewController(pageUrlString: websiteVC.getUrlString() == "about:blank" ? "" : websiteVC.getUrlString())
        newVC.didSelectBookmarkCompletion = {[weak self] bookmark in
            if bookmark != self?.websiteVC.getUrlString() {
                self?.websiteVC.loadUrl(urlString: bookmark)
            } else {
                self?.websiteVC.reload()
            }
        }
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc private func didTapRefreshButton() {
        websiteVC.reload()
        searchBar.text = websiteVC.getUrlString()
    }
    
    private func setupButtonStates() {
        if self.getUrlString() == "about:blank" {
            self.searchBar.text = ""
            self.canRefresh = false
        } else {
            self.searchBar.text = self.getUrlString()
            self.canRefresh = true
        }
        
        if self.websiteVC.getCanGoback() == false {
            self.canGoBack = false
        } else {
            self.canGoBack = true
        }

        if self.websiteVC.getCanGoForward() == false {
            self.canGoForward = false
        } else {
            self.canGoForward = true
        }
    }
    
    private func setupCompletionHandlers() {

        websiteVC.didGoBackForwardCompletion = { [weak self] in
            self?.setupButtonStates()
        }
        
        websiteVC.couldLoadCompletion = { [weak self] in
            self?.setupButtonStates()
        }
        
        websiteVC.couldNotLoadCompletion = { [weak self] errorString in
            let alertVC = UIAlertController(title: "Could Not Load", message: errorString, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(ok)
            self?.present(alertVC, animated: true, completion: nil)
        }
    }
    
    public func getUrlString() -> String {
        return websiteVC.getUrlString()
    }
}

extension TabViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if text == "" {
            searchBar.text = websiteVC.getUrlString() == "about:blank" ? text : websiteVC.getUrlString()
        } else {
            searchBar.text = text
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let urlString = searchBar.text else {
            return
        }
        websiteVC.loadUrl(urlString: urlString)
        
    }
}
