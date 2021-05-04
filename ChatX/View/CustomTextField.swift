//
//  CredInputTextField.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit

final class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        
        returnKeyType = .done
        autocorrectionType = .no
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.foregroundColor : UIColor.lightGray])
        textColor = .darkGray
        font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        layer.borderWidth = 1.0
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderColor = UIColor(cgColor:#colorLiteral(red: 0.2427886426, green: 0.4366536736, blue: 0.7726411223, alpha: 1)).cgColor
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
