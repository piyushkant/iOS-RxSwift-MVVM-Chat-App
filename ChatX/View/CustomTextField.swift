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
        attributedPlaceholder =
            NSAttributedString(string: placeHolder, attributes: [.foregroundColor : UIColor(cgColor:#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))])
        textColor = UIColor(cgColor:#colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1))
        font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        layer.borderWidth = 1.0
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderColor = UIColor(cgColor:#colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1)).cgColor
        tintColor = UIColor(cgColor:#colorLiteral(red: 0, green: 0.7599403262, blue: 0.9988735318, alpha: 1))
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
    
    private var placeholderBackup: String?

    override func becomeFirstResponder() -> Bool {
        placeholderBackup = placeholder
        placeholder = nil
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        placeholder = placeholderBackup
        return super.resignFirstResponder()
    }
}

//UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
