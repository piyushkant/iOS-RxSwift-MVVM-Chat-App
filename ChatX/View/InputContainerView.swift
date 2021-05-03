//
//  InputContainerView.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit
import SnapKit

final class InputContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(image: UIImage?, textField: UITextField) {
        super.init(frame: .zero)
        let imageView = UIImageView(image: image)
        let underline = UIView()
        
        [imageView, textField, underline].forEach({ addSubview($0)})
        underline.backgroundColor = .white
        underline.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(1)
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-2)
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(30)
        }
        
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}
