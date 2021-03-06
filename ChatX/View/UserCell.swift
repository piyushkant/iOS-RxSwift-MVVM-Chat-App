//
//  UserCell.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import SnapKit
import SDWebImage

final class UserCell: UITableViewCell {
    static let reuseIdentifier = "UserCell"
        
    var user: User? {
        didSet {
            setupCell()
        }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Initial Setup
    private func setupUI() {
        addSubview(profileImageView)
        selectedBackgroundView?.isHidden = true
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(56)
        }
        profileImageView.layer.cornerRadius = 56 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
    }
    
    
    // MARK: - Cell Setter
    private func setupCell() {
        guard let user = user else { return }
        let url = URL(string: user.profileImageUrl)
        profileImageView.sd_setImage(with: url)
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
}
