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
    
    private lazy var emailContainer = InputContainerView(image: #imageLiteral(resourceName: "mail"), textField: emailTextField)
    private lazy var passwordContainer = InputContainerView(image: #imageLiteral(resourceName: "lock"), textField: passwordTextField)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Initial UI Setup
    func setupUI() {
        self.setupDetailAttributesOfUI()
        self.setupAppLogoImageView()
        self.setupAuthStackView()
        self.setupTapGesture()
    }

    private func setupDetailAttributesOfUI() {
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .default
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
        let stackView = UIStackView(arrangedSubviews: [emailContainer, passwordContainer, loginButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 10
        
        [emailContainer, passwordContainer, loginButton].forEach({
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        })
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(appLogoImageView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    private func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // MARK: - Binding
    func bind() {
        
    }
}

