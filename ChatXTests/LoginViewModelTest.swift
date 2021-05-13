//
//  LoginViewModelTests.swift
//  ChatXTests
//
//  Created by Piyush Kant on 2021/05/12.
//

import XCTest
import RxSwift
import RxBlocking
import RxNimble
import Nimble

@testable import ChatX

class LoginViewModelTest : XCTestCase {
    var viewModel: LoginViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        
        viewModel = LoginViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    func testLoginForm_WhenEmailIsValidAndPasswordIsValid_FormShouldBeValid() throws {
        let isFormValidObservable = viewModel.isFormValid.asObservable().subscribe(on: scheduler)
        
        viewModel.email.accept("test@mail.com")
        viewModel.password.accept("password")
        
        expect(self.viewModel.email).first == "test@mail.com"
        expect(self.viewModel.password).first == "password"
        
        XCTAssertEqual(try isFormValidObservable.toBlocking(timeout: 1.0).first(), true)
    }
    
    func testLoginForm_WhenEmailIsValidAndPasswordIsInValid_FormShouldBeInValid() throws {
        let isFormValidObservable = viewModel.isFormValid.asObservable().subscribe(on: scheduler)
        
        viewModel.email.accept("test@mail.com")
        viewModel.password.accept("pass")
        
        expect(self.viewModel.email).first == "test@mail.com"
        expect(self.viewModel.password).first == "pass"
        
        XCTAssertEqual(try isFormValidObservable.toBlocking(timeout: 1.0).first(), false)
    }
    
    func testLoginForm_WhenEmailIsInValidAndPasswordIsValid_FormShouldBeInValid() throws {
        let isFormValidObservable = viewModel.isFormValid.asObservable().subscribe(on: scheduler)

        viewModel.email.accept("testmail.com")
        viewModel.password.accept("password")
        
        expect(self.viewModel.email).first == "testmail.com"
        expect(self.viewModel.password).first == "password"

        XCTAssertEqual(try isFormValidObservable.toBlocking(timeout: 1.0).first(), false)
    }

    func testLoginForm_WhenEmailIsInValidAndPasswordIsInValid_FormShouldBeInValid() throws {
        let isFormValidObservable = viewModel.isFormValid.asObservable().subscribe(on: scheduler)

        viewModel.email.accept("testmail.com")
        viewModel.password.accept("pass")
        
        expect(self.viewModel.email).first == "testmail.com"
        expect(self.viewModel.password).first == "pass"

        XCTAssertEqual(try isFormValidObservable.toBlocking(timeout: 1.0).first(), false)
    }
}
