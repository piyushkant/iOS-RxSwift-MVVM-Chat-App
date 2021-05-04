//
//  ProfileViewModelBindable.swift
//  ChatX
//
//  Created by Piyush Kant on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileViewModelBindable: ViewModelType {
    var user: Driver<User?> { get }
}
