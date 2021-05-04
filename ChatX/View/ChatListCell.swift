//
//  ChatListCell.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import SDWebImage

final class ChatListCell: UITableViewCell {
    
    static let reuseIdentifier = "ChatListCell"
    
    // MARK: - Properties
    var conversation: Conversation? {
        didSet{
            setupCell()
        }
    }
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let messageLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    private let timeStampLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    private func setupUI() {
        [profileImageView, nameLabel, messageLabel, timeStampLabel].forEach({contentView.addSubview($0)})
        selectedBackgroundView?.isHidden = true
        profileImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(56)
        }
        profileImageView.layer.cornerRadius = 56 / 2
        profileImageView.clipsToBounds = true
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(nameLabel)
        }
        
        timeStampLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    // MARK: - Cell Setter
    private func setupCell() {
        guard let conversation = self.conversation else { return }
        guard let url = URL(string: conversation.user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
        nameLabel.text = conversation.user.username
        messageLabel.text = conversation.recentMessage.text
        let date = conversation.recentMessage.timestamp.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd hh:mm a"
        timeStampLabel.text = formatter.string(from: date)
    }
}
