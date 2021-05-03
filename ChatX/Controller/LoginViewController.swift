//
//  LoginViewController.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import JGProgressHUD

protocol LoginViewModelBindable: ViewModelType {
    // Input
    var email: BehaviorSubject<String> { get }
    var password: BehaviorSubject<String> { get }
    var loginButtonTapped: PublishRelay<Void> { get }
    
    // Output
    var isLoginCompleted: Signal<Bool> { get }
    var isValidForm: Driver<Bool> { get }
}

class LoginViewController: UIViewController, ViewType {
    
    var viewModel: LoginViewModelBindable!
    var disposeBag: DisposeBag!
    
    private let appLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Images.appLogo)
        iv.layer.cornerRadius = 3
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Initial UI Setup
    func setupUI() {
        self.setupAppLogoImageView()
    }
    
    private func setupAppLogoImageView() {
        self.view.addSubview(self.appLogoImageView)
        self.appLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.width.equalTo(300)
            $0.height.equalTo(200)
        }
    }
    
    // MARK: - Binding
    func bind() {
        
    }
}

