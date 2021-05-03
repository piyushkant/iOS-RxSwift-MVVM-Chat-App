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
    
    private let emailTextField = CredInputTextField(placeHolder: "Email")
    private let passwordTextField = CredInputTextField(placeHolder: "Password")
    private let loginButton = LoginButton(title: "Login", color:#colorLiteral(red: 0.2427886426, green: 0.4366536736, blue: 0.7726411223, alpha: 1))
    
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
        self.setupAuthStackView()
    }
    
    private func setupAppLogoImageView() {
        self.view.addSubview(self.appLogoImageView)
        self.appLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
    }
    
    private func setupAuthStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        
        [emailTextField, passwordTextField, loginButton].forEach({
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        })
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(appLogoImageView.snp.bottom).offset(50)
            $0.trailing.leading.equalToSuperview().offset(50)
        }
    }
    
    // MARK: - Binding
    func bind() {
        
    }
}

