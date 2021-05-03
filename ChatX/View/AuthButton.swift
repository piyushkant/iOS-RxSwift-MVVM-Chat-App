//
//  LoginButton.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit

final class AuthButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, color: UIColor) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = color
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        clipsToBounds = true
        isEnabled = false
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
}
