//
//  BaseViewProtocol.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/03.
//

import UIKit
import RxSwift


protocol BaseViewProtocol: AnyObject {
    
    associatedtype VM
    
    var viewModel: VM! { get set }
    var disposeBag: DisposeBag! { get set }
    func setupUI()
    func bind()
}

extension BaseViewProtocol where Self: UIViewController {
    static func create(with viewModel: VM) -> Self {
        let `self` = Self()
        
        self.viewModel = viewModel
        
        // Initial Setup
        self.disposeBag = DisposeBag()
        self.loadViewIfNeeded()
        self.setupUI()
        self.bind()
        return self
    }
}
