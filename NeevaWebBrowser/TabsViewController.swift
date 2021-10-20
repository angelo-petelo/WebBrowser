//
//  TabsViewController.swift
//  NeevaWebBrowser
//
//  Created by Nicholas Angelo Petelo on 10/17/21.
//

import UIKit

class TabsViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .darkGray
        label.text = "Tabs"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.init(name: "Helvetica Neue Thin", size: 30)
        return label
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
    
    let addTabButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30))), for: .normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()
    
    let rightFooterViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setTitle("Edit", for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(didTapRightFooterViewButton), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    var tabsList: [TabViewController] = [TabViewController()] {
        didSet {
            self.setupCompletionHandlers()
            self.tableView.reloadData()
        }
    }
    
    var isInitialLoadFlag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        self.navigationController?.isNavigationBarHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        configureViews()
        configureConstraints()
        setupCompletionHandlers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isInitialLoadFlag {
            self.navigationController?.pushViewController(tabsList[0], animated: true)
            isInitialLoadFlag = false
        }
        self.tableView.reloadData()
    }
    
    private func configureViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(addTabButton)
        footerView.addSubview(rightFooterViewButton)
    }
    
    private func configureConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //Title Label constraints
        constraints.append(titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70))
        
        // Table View constraints
        constraints.append(tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70))
        
        //Footer View constraints
        constraints.append(footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor))
        constraints.append(footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        
        //Add Button constraints
        constraints.append(addTabButton.heightAnchor.constraint(equalToConstant: 30))
        constraints.append(addTabButton.widthAnchor.constraint(equalToConstant: 30))
        constraints.append(addTabButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor))
        constraints.append(addTabButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor))
        
        //Right Footer View Button constraints
        constraints.append(rightFooterViewButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor))
        constraints.append(rightFooterViewButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -30))

        view.addConstraints(constraints)
    }
    
    private func setupCompletionHandlers() {
        for vc in tabsList {
            vc.didTapAddCompletion = { [weak self] newVC in
                self?.tabsList.append(newVC)
            }
        }
    }
    
    @objc private func didTapAddButton() {
        let newTabVC = TabViewController()
        tabsList.append(newTabVC)
        if tableView.isEditing {
            self.rightFooterViewButton.setTitle("Done", for: .normal)
        } else {
            self.rightFooterViewButton.setTitle("Edit", for: .normal)
        }
        self.rightFooterViewButton.setTitleColor(.white, for: .normal)
        self.rightFooterViewButton.isUserInteractionEnabled = true
        self.tableView.reloadData()
    }
    
    @objc private func didTapRightFooterViewButton() {
        if (self.tableView.isEditing == true) {
            self.rightFooterViewButton.setTitle("Edit", for: .normal)
            self.tableView.isEditing = false
        } else {
            self.rightFooterViewButton.setTitle("Done", for: .normal)
            self.tableView.isEditing = true
        }
    }
}

extension TabsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabVC = tabsList[indexPath.row]
        tabVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tabsList.remove(at: indexPath.row)
            if tabsList.isEmpty {
                self.rightFooterViewButton.setTitle("Edit", for: .normal)
                self.rightFooterViewButton.setTitleColor(.gray, for: .normal)
                self.rightFooterViewButton.isUserInteractionEnabled = false
            }
        }
    }
}

extension TabsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabVC = tabsList[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = tabVC.getUrlString() == "about:blank" ? "New Tab" : tabVC.getUrlString()
        return cell
    }
    
    
}
