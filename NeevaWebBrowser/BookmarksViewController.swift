//
//  BookmarksViewController.swift
//  NeevaWebBrowser
//
//  Created by Nicholas Angelo Petelo on 10/19/21.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .darkGray
        label.text = "Bookmarks"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.init(name: "Helvetica Neue Thin", size: 30)
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setTitle("Done", for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let footerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    let addPageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Current Page", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.isUserInteractionEnabled = false
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    let rightFooterViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.gray, for: .normal)
        button.setTitle("Edit", for: .normal)
        button.isUserInteractionEnabled = false
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(didTapRightFooterViewButton), for: .touchUpInside)
        return button
    }()
    
    let pageUrlString: String
    var canAddPage: Bool = false {
        didSet {
            if canAddPage {
                self.addPageButton.isUserInteractionEnabled = true
                self.addPageButton.setTitleColor(.white, for: .normal)
            } else {
                self.addPageButton.isUserInteractionEnabled = false
                self.addPageButton.setTitleColor(.gray, for: .normal)
            }
        }
    }
    var bookmarks: [String] = [] {
        didSet {
            if isUrlAlreadyBookmark() || pageUrlString.isEmpty {
                canAddPage = false
            } else {
                canAddPage = true
            }
            
            if bookmarks.isEmpty {
                rightFooterViewButton.setTitleColor(.gray, for: .normal)
                rightFooterViewButton.isUserInteractionEnabled = false
            } else {
                rightFooterViewButton.setTitleColor(.white, for: .normal)
                rightFooterViewButton.isUserInteractionEnabled = true
            }
            self.tableView.reloadData()
        }
    }
    var didSelectBookmarkCompletion: ((String) -> Void)?
    
    init(pageUrlString: String) {
        self.pageUrlString = pageUrlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        configureViews()
        configureConstraints()
        tableView.delegate = self
        tableView.dataSource = self
        bookmarks = UserDefaults.standard.object(forKey: "bookmarks") as? [String] ?? [String]()
        configureButtonStates()
    }
    
    private func configureViews() {
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(doneButton)
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(addPageButton)
        footerView.addSubview(rightFooterViewButton)
    }
    
    private func configureConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //Header View constraints
        constraints.append(headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(headerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70))
        
        //Title Label constraints
        constraints.append(titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor))
        constraints.append(titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor))
        
        //Done Button constraints
        constraints.append(doneButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor))
        constraints.append(doneButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -30))
        
        //Table View constraints
        constraints.append(tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70))
        
        //Footer View constraints
        constraints.append(footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor))
        constraints.append(footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        //Add Page Button constraints
        constraints.append(addPageButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor))
        constraints.append(addPageButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor))
        
        //Right Footer View Button constraints
        constraints.append(rightFooterViewButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor))
        constraints.append(rightFooterViewButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -30))
        
        view.addConstraints(constraints)
    }
    
    private func configureButtonStates() {
        if !bookmarks.isEmpty {
            rightFooterViewButton.setTitleColor(.white, for: .normal)
            rightFooterViewButton.isUserInteractionEnabled = true
        }
        if !pageUrlString.isEmpty && !isUrlAlreadyBookmark(){
            canAddPage = true
        }
    }
    
    private func isUrlAlreadyBookmark() -> Bool {
        return bookmarks.contains(pageUrlString)
    }
    
    private func addBookmark(urlString: String) {
        bookmarks.append(urlString)
    }
    
    private func saveBookmarks() {
        UserDefaults.standard.set(bookmarks, forKey: "bookmarks")
    }
    
    @objc private func didTapDoneButton() {
        saveBookmarks()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapAddButton() {
        addBookmark(urlString: pageUrlString)
        canAddPage = false
    }
    
    @objc private func didTapRightFooterViewButton() {
        if tableView.isEditing {
            tableView.isEditing = false
            rightFooterViewButton.setTitle("Edit", for: .normal)
        } else {
            tableView.isEditing = true
            rightFooterViewButton.setTitle("Done", for: .normal)
        }
    }
}

extension BookmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            bookmarks.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveBookmarks()
        didSelectBookmarkCompletion?(bookmarks[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

extension BookmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = bookmarks[indexPath.row]
        return cell
    }
    
    
}
