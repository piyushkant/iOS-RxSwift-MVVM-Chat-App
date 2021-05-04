//
//  ProfileViewController.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UITableViewController, ViewType {
    
    // MARK: - Properties
    private lazy var headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 380))
    private lazy var footerView = ProfileFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
    
    var disposeBag: DisposeBag!
    var viewModel: ProfileViewModelBindable!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Initial setup
    func setupUI() {
        tableView = UITableView(frame: view.frame, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 80
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .systemGroupedBackground
    }
    
    // MARK: - Binding
    func bind() {
        
        // UI binding
        headerView.dismissButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        footerView.logoutButton.rx.tap
            .subscribe(onNext:{ [unowned self] in
                self.logoutCurrentUser { (error) in
                    if let err = error {
                        print("Failed to logged out:", err)
                        return
                    }
                    print("Successfully logged out this user")
                    self.switchToLoginVC()
                }
            })
        
        // ViewModel -> Output
        viewModel.user
            .drive(onNext: { [weak self] in
                guard let user = $0 else { return }
                self?.headerView.user.accept(user)
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
