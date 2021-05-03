//
//  SignupViewController.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

protocol SignupViewModelBindable: ViewModelType {
    // Input
    var profileImage: PublishRelay<UIImage?> { get }
    var email: PublishRelay<String> { get }
    var fullName: PublishRelay<String> { get }
    var userName: PublishRelay<String> { get }
    var password: PublishRelay<String> { get }
    var signupButtonTapped: PublishRelay<Void> { get }
    
    // Output
    var isRegistering: Driver<Bool> { get }
    var isRegistered: Signal<Bool> { get }
    var isFormValid: Driver<Bool> { get }
}

final class SignupViewController: UIViewController, ViewType {
    
    // MARK: - Properties
    let addPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "AddPhoto"), for: .normal)
        btn.tintColor = .darkGray
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }()
    
    private lazy var emailContainer = InputContainerView(image: #imageLiteral(resourceName: "mail"), textField: emailTextField)
    private let emailTextField = InputTextField(placeHolder: "Email")
    
    private lazy var fullNameContainer = InputContainerView(image: #imageLiteral(resourceName: "mail"), textField: fullNameTextField)
    private let fullNameTextField = InputTextField(placeHolder: "Full Name")
    
    private lazy var userNameContainer = InputContainerView(image: #imageLiteral(resourceName: "mail"), textField: userNameTextField)
    private let userNameTextField = InputTextField(placeHolder: "Username")
    
    private lazy var passwordContainer = InputContainerView(image: #imageLiteral(resourceName: "mail"), textField: passwordTextField)
    private let passwordTextField = InputTextField(placeHolder: "Password")
        
    private let signUpButton: UIButton = AuthButton(title: "Sign Up", color: #colorLiteral(red: 0.244713217, green: 0.4361641705, blue: 0.7726119161, alpha: 1))
    
    private let loginPageButton = SignupButton(firstText: "Already have an account? ", secondText: "Log In")
    
    private lazy var stackContents = [
        emailContainer,
        fullNameContainer,
        userNameContainer,
        passwordContainer,
        signUpButton
    ]
    
    private let stackView = UIStackView()
    
    var viewModel: SignupViewModelBindable!
    var disposeBag: DisposeBag!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        
//        signUpButton.isEnabled = true
//        signUpButton.backgroundColor =  true ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) : #colorLiteral(red: 0.244713217, green: 0.4361641705, blue: 0.7726119161, alpha: 1)
    }
    
    func setupUI() {
        setupUIAttributeThings()
        setupAddPhotoButton()
        setupInputStackView()
        setupLoginPageButton()
        setTapGesture() 
    }
    
    
    private func setupUIAttributeThings() {
        passwordTextField.isSecureTextEntry = true
        emailTextField.keyboardType = .emailAddress
    }
    
    private func setupAddPhotoButton() {
        view.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
            $0.width.height.equalTo(200)
        }
    }
    
    private func setupInputStackView() {
        stackContents.forEach({ stackView.addArrangedSubview($0) })
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.setCustomSpacing(10, after: passwordContainer)
        stackContents.forEach({
            $0.snp.makeConstraints {
                $0.height.equalTo(50)
            }
        })
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(addPhotoButton.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    private func setupLoginPageButton() {
        view.addSubview(loginPageButton)
        loginPageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    // MARK: - Binding
    func bind() {
        print("SignupViewController", "bind()")
        
        // Input -> ViewModel
        signUpButton.rx.tap
            .bind(to: viewModel.signupButtonTapped)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        fullNameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.fullName)
            .disposed(by: disposeBag)
        
        userNameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.userName)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        
        // viewModel -> Output
        viewModel.isFormValid
            .drive(onNext: { [weak self] in
                self?.signUpButton.isEnabled = $0
                self?.signUpButton.backgroundColor =  $0 ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) : #colorLiteral(red: 0.244713217, green: 0.4361641705, blue: 0.7726119161, alpha: 1)
            })
            .disposed(by: disposeBag)
        
        viewModel.profileImage
            .bind(to: self.rx.setProfileImage)
            .disposed(by: disposeBag)
        
        viewModel.isRegistering
            .drive(onNext: {[weak self] in
                self?.showActivityIndicator($0, withText: $0 ? "Registering" : nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.isRegistered
            .filter{ $0 == true }
            .emit(onNext: { [weak self] _ in
//                self?.switchToConversationVC()
                print("isRegistered", "Success!!!!")
            })
            .disposed(by: disposeBag)
        
        
        // UI Binding
        addPhotoButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.didTapAddPhotoButton(viewController: self)
            })
            .disposed(by: disposeBag)
        
        loginPageButton.rx.tap
            .subscribe(onNext:{ [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        
        // Notification binding
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { [weak self] notification -> CGFloat in
                guard let self = self else { fatalError() }
                return self.getKeyboardFrameHeight(notification: notification)
            }
            .subscribe(onNext: { [weak self] in
                self?.view.transform = CGAffineTransform(translationX: 0, y: -$0 - 8)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] noti -> Void in
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 1,
                               options: .curveEaseOut,
                               animations: {
                    self?.view.transform = .identity
                })
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    private func getKeyboardFrameHeight(notification: Notification) -> CGFloat {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        let keyboardHeight = value.cgRectValue.height
        let bottomSpace = self.view.frame.height - (self.stackView.frame.origin.y + self.stackView.frame.height)
        let lengthToMoveUp = keyboardHeight - bottomSpace
        return lengthToMoveUp
    }
}


// MARK: - UIImagePickerControllerDelegate
extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("finished image pick")
        let image = info[.originalImage] as? UIImage
        viewModel.profileImage.accept(image)
        picker.dismiss(animated: true)
    }
}
