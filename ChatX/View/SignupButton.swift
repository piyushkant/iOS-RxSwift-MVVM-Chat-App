//
//  SignupButton.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit

final class SignupButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(firstText: String, secondText: String) {
        self.init(frame: .zero)
        configure(firstText: firstText, secondText: secondText)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(firstText: String, secondText: String) {
        let attributedTitle = NSMutableAttributedString(string: firstText,
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor : UIColor.white])
        attributedTitle.append(NSAttributedString(string: secondText,
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor : UIColor.white]))
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
