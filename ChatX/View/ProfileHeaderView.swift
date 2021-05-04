//
//  ProfileHeaderView.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileHeaderView: UIView {
    
    // MARK: - Properties
    
    var user = PublishRelay<User>()
    var disposeBag = DisposeBag()
    
    let dismissButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark",
                             withConfiguration: UIImage.SymbolConfiguration(scale:.large))?
                        .withRenderingMode(.alwaysOriginal), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradientLayer()
        configureUI()
    }
    
    
    // MARK: - Initial Setup
    private func configureUI() {
        [dismissButton, profileImageView].forEach({addSubview($0)})
        
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(45)
            $0.leading.equalToSuperview().offset(9)
            $0.width.height.equalTo(45)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(80)
            $0.width.height.equalTo(200)
        }
        profileImageView.layer.cornerRadius = 200 / 2
        
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.centerX.equalTo(profileImageView)
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
        }
    }
    
    private func configureGradientLayer() {
        let gradient = CAGradientLayer()
        let topColor = #colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1).cgColor
        let bottomColor = #colorLiteral(red: 0.001363703748, green: 0.4848565459, blue: 0.9982791543, alpha: 1).cgColor
        gradient.colors = [topColor, bottomColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
    }
    
    
    // MARK: - Bind
    private func bind() {
        user
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.fullNameLabel.text = $0.fullname
                self.userNameLabel.text = "@" + $0.username
                guard let url = URL(string: $0.profileImageUrl) else { return }
                self.profileImageView.sd_setImage(with: url)
            })
            .disposed(by: disposeBag)
    }
}
