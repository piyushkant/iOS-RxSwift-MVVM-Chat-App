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
        setupNavigationBar(with: "Messages", prefersLargeTitles: true)
    }
    
    // MARK: - Initial Setup
    func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: nil, action: nil)
        setupAddMessageButton()
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
        navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: { [unowned self] in
                //                let profileController = ProfileController.create(with: ProfileViewModel())
                //                let navi = UINavigationController(rootViewController: profileController)
                //                navi.modalPresentationStyle = .fullScreen
                //                navi.modalTransitionStyle = .coverVertical
                //                self.present(navi, animated: true)
            })
            .disposed(by: disposeBag)
        
        addMessageButton.rx.tap
            .subscribe(onNext:{ [unowned self] in
                //                let newMessageVC = NewMessageController.create(with: NewMessageViewModel())
                //                self.newMessageControllerBind(newMsgVC: newMessageVC)
                //                let newMessageVCNavi = UINavigationController(rootViewController: newMessageVC)
                //                newMessageVCNavi.modalPresentationStyle = .fullScreen
                //                self.present(newMessageVCNavi, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Conversation.self)
            .subscribe(onNext: {[unowned self] conversation in
                //                let chatVC = ChatController.create(with: ChatViewModel(user: conversation.user))
                //                self.navigationController?.pushViewController(chatVC, animated: true)
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
}
