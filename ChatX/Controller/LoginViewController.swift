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

class LoginViewController: UIViewController, ViewType {
    
    var viewModel: LoginViewModelBindable!
    var disposeBag: DisposeBag!
    
    private let appLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "AppLogo")
        iv.layer.cornerRadius = 3
        iv.clipsToBounds = true
        return iv
    }()
    private let emailTextField = CustomTextField(placeHolder: "Email")
    private let passwordTextField = CustomTextField(placeHolder: "Password")
    private let loginButton = AuthButton(title: "Log In", color:#colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1))
    private let bottomButton = BottomButton(firstText: "Create a new account. ", secondText: "Sign Up")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Initial UI Setup
    func setupUI() {
        self.setupDetailAttributesOfUI()
        self.setupAppLogoImageView()
        self.setupAuthStackView()
        self.setupSignupButton()
        self.setupTapGesture()
    }
    
    private func setupDetailAttributesOfUI() {
        view.backgroundColor = .white
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
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    private func setupSignupButton() {
        self.view.addSubview(self.bottomButton)
        self.bottomButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // MARK: - Binding
    func bind() {
        
        //Input -> ViewModel
        emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        //viewModel -> Output
        viewModel.isValidForm
            .drive(onNext: { [weak self] in
                self?.loginButton.isEnabled = $0
                self?.loginButton.backgroundColor = $0 ? #colorLiteral(red: 0.001363703748, green: 0.4848565459, blue: 0.9982791543, alpha: 1) : #colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoginCompleted
            .emit(onNext: { [weak self] _ in
                self?.showActivityIndicator(false)
                self?.switchToConversationVC()
            })
            .disposed(by: disposeBag)
        
        // UI Binding
        loginButton.rx.tap
            .do(onNext: { [unowned self] _ in
                self.showActivityIndicator(true)
            })
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let vc = SignupViewController.create(with: SignupViewModel())
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
}

