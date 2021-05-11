//
//  ChatListViewController.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatListViewController: UIViewController, ViewType {
    
    // MARK: - Properties
    private let tableView = UITableView()
    private let addMessageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1)
        btn.tintColor = .white
        return btn
    }()
    
    var disposeBag: DisposeBag!
    var viewModel: ChatListViewModelBindable!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(with: "ChatX", prefersLargeTitles: false)
    }
    
    // MARK: - Initial Setup
    func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        setupRightBarButton()
        setupAddMessageButton()
    }
    
    private func setupRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Logout"), style: .plain, target: nil, action: nil)
    }
    
    private func setupAddMessageButton() {
        view.addSubview(addMessageButton)
        addMessageButton.layer.cornerRadius = 56 / 2
        addMessageButton.clipsToBounds = true
        addMessageButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.trailing.equalTo(view.snp.trailing).inset(24)
            $0.width.height.equalTo(56)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.frame = view.frame
        tableView.tableFooterView = UIView()
        tableView.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.reuseIdentifier)
    }
    
    // MARK: - Binding
    func bind() {
        
        // UI Binding
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.logoutAlert()
            })
            .disposed(by: disposeBag)
        
        addMessageButton.rx.tap
            .subscribe(onNext:{ [unowned self] in
                let vc = FriendListViewController.create(with: FriendListViewModel())
                self.addMessageControllerBind(vc: vc)
                let nc = UINavigationController(rootViewController: vc)
                nc.modalPresentationStyle = .fullScreen
                self.present(nc, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Conversation.self)
            .subscribe(onNext: {[unowned self] conversation in
                let chatVC = ChatViewController.create(with: ChatViewModel(user: conversation.user))
                self.navigationController?.pushViewController(chatVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] in
                self.tableView.deselectRow(at: $0, animated: true)
            })
            .disposed(by: disposeBag)
        
        
        // ViewModel -> Output
        viewModel.conversations
            .bind(to: tableView.rx.items(cellIdentifier: ChatListCell.reuseIdentifier, cellType: ChatListCell.self)) { row, conversation, cell in
                cell.conversation = conversation
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Binding Helper
    private func addMessageControllerBind(vc: FriendListViewController) {
        vc.tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] user in
                let chatVC = ChatViewController.create(with: ChatViewModel(user: user))
                vc.searchController.dismiss(animated: true)
                vc.dismiss(animated: true)
                self?.navigationController?.pushViewController(chatVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func logoutAlert() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to log out?", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Log Out", comment: ""), style: .destructive, handler: { (action) in
            self.logoutCurrentUser { (error) in
                if let err = error {
                    print("Failed to logged out:", err)
                    return
                }
                print("Successfully logged out this user")
                self.switchToLoginVC()
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
