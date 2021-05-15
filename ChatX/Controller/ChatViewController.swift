//
//  ChatViewController.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatViewController: UIViewController, BaseViewProtocol {
    
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    
    private let customInputView = CustomInputView()
    var viewModel: ChatViewModelModeling!
    var disposeBag: DisposeBag!
    
    private let tapGesture = UITapGestureRecognizer()
    private let coverView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coverView.backgroundColor = .white
        coverView.frame = collectionView.bounds
        collectionView.addSubview(coverView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if collectionView.contentSize.height > collectionView.frame.height {
            let lengthToScroll = collectionView.contentSize.height - collectionView.frame.height
            collectionView.contentOffset.y = lengthToScroll
        }
        coverView.removeFromSuperview()
    }
    
    func setupUI() {
        setupCollectionView()
        setupCustomInputView()
        setupTapGesture()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
        }
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseID)
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width, height: 50)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func setupCustomInputView() {
        view.addSubview(customInputView)
        customInputView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(50)
        }
    }
    
    private func setupTapGesture() {
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Binding
    func bind() {
        
        // MARK: - ViewModel
        customInputView.sendButton.rx.tap
            .bind(to: viewModel.sendButtonTapped)
            .disposed(by: disposeBag)
        
        customInputView.messageInputTextView.rx.text
            .orEmpty
            .bind(to: viewModel.inputText)
            .disposed(by: disposeBag)
        
        
        // MARK: - Output
        viewModel.userData
            .subscribe(onNext: { [weak self] in
                guard let user = $0 else { return }
                self?.setupNavigationBar(with: user.username, prefersLargeTitles: false)
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                viewModel.messages,
                viewModel.userData
            )
            .map{ (messages, user) -> [Message] in
                return messages.map{ Message(original: $0, user: user!) }
            }
            .bind(to: collectionView.rx.items(cellIdentifier: MessageCell.reuseID, cellType: MessageCell.self)) { index, message, cell in
                cell.message = message
            }
            .disposed(by: disposeBag)
        
        viewModel.isMessageUploaded
            .filter{ $0 }
            .drive(onNext: { [weak self] _ in
                self?.customInputView.clearMessageText()
            })
            .disposed(by: disposeBag)
        
        
        // MARK: - UI Binding
        tapGesture.rx.event
            .subscribe(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        
        // MARK: - Notification Binding
        NotificationCenter.default.rx.notification(Notification.Name("didFinishUploadMessage"))
            .subscribe(onNext:{ [weak self] (noti) in
                guard let self = self else { return }
                self.collectionView.layoutIfNeeded()
                if (self.collectionView.contentSize.height + self.topbarHeight) > self.collectionView.frame.height {
                    let count = self.viewModel.messages.value.count
                    self.collectionView.scrollToItem(at: IndexPath(item: count - 1, section: 0), at: .bottom, animated: true)
                    self.collectionView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext:{ [weak self] notification in
                guard let self = self else { return }
                let height = self.getKeyboardFrameHeight(notification: notification)
                let bottomInset = self.view.safeAreaInsets.bottom
                
                if self.collectionView.contentSize.height + self.topbarHeight > self.view.frame.height - (height + self.customInputView.frame.height) {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -height + bottomInset)
                } else {
                    self.customInputView.transform = CGAffineTransform(translationX: 0, y: -height + bottomInset)
                }
                
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: {[weak self] notification in
                guard let self = self else { return }
                let height = self.getKeyboardFrameHeight(notification: notification)
                
                if self.collectionView.contentSize.height + self.topbarHeight > self.view.frame.height - (height + self.customInputView.frame.height) {
                    self.view.transform = .identity
                }
                self.customInputView.transform = .identity
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Helper
    func getKeyboardFrameHeight(notification: Notification) -> CGFloat {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            fatalError()
        }
        let keyboardFrame = value.cgRectValue
        return keyboardFrame.height
    }
}
