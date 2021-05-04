//
//  FriendListViewController.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

final class FriendListViewController: UIViewController, ViewType {
    
    // MARK: - Properties
    let tableView = UITableView()
    let searchController = UISearchController()
    private let refresh = UIRefreshControl()
    private let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
    
    var viewModel: FriendListViewModelBindable!
    var disposeBag: DisposeBag!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(with: "Friend List", prefersLargeTitles: false)
    }
    
    // MARK: - Initial Setup
    func setupUI() {
        navigationItem.rightBarButtonItem = cancelButton
        setupTableView()
        setupSearchBar()
        setupRefreshController()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    
    private func setupSearchBar() {
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func setupRefreshController() {
        refresh.tintColor = #colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1)
        self.tableView.refreshControl = refresh
    }
    
    // MARK: - Binding
    func bind() {
        
        // Input -> ViewModel
        refresh.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.refreshPulled)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .bind(to: viewModel.searchCancelButtonTapped)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.filterKey)
            .disposed(by: disposeBag)
        
        
        // ViewModel -> Output
        viewModel.users
            .bind(to: tableView.rx.items(cellIdentifier: UserCell.reuseIdentifier, cellType: UserCell.self)) { row, user, cell in
                cell.user = user
            }
            .disposed(by: disposeBag)
        
        viewModel.isNetworking
            .drive(refresh.rx.spinner)
            .disposed(by: disposeBag)
        
        // UI Bind
        cancelButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
