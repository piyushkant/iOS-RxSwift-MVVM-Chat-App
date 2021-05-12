//
//  LoginViewModelTests.swift
//  ChatXTests
//
//  Created by Piyush Kant on 2021/05/12.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import ChatX

class LoginViewModelTest : XCTestCase {
    var viewModel: LoginViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        
        viewModel = LoginViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testFormIsValidWhenEmailIsValidAndPasswordLengthIsMoreThanSix() throws {
        let isValidFormObservable = viewModel.isValidForm.asObservable().subscribe(on: scheduler)
        
        viewModel.email.accept("test@mail.com")
        viewModel.password.accept("password")
        
        XCTAssertEqual(try isValidFormObservable.toBlocking(timeout: 1.0).first(), true)
    }
    
    func testFormIsInValidWhenEmailIsValidAndPasswordLengthIsLessThanSix() throws {
        let isValidFormObservable = viewModel.isValidForm.asObservable().subscribe(on: scheduler)
        
        viewModel.email.accept("test@mail.com")
        viewModel.password.accept("pass")
        
        XCTAssertEqual(try isValidFormObservable.toBlocking(timeout: 1.0).first(), false)
    }
    
    func testFormIsInValidWhenEmailIsInValidAndPasswordLengthIsMoreThanSix() throws {
        let isValidFormObservable = viewModel.isValidForm.asObservable().subscribe(on: scheduler)

        viewModel.email.accept("testmail.com")
        viewModel.password.accept("password")

        XCTAssertEqual(try isValidFormObservable.toBlocking(timeout: 1.0).first(), false)
    }

    func testFormIsValidWhenEmailIsInValidAndPasswordLengthIsLessThanSix() throws {
        let isValidFormObservable = viewModel.isValidForm.asObservable().subscribe(on: scheduler)

        viewModel.email.accept("testmail.com")
        viewModel.password.accept("pass")

        XCTAssertEqual(try isValidFormObservable.toBlocking(timeout: 1.0).first(), false)
    }
}
