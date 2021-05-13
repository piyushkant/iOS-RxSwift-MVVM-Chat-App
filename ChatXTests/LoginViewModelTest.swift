//
//  LoginViewModelTests.swift
//  ChatXTests
//
//  Created by Piyush Kant on 2021/05/12.
//

import XCTest
import RxSwift
import RxBlocking
import Quick
import Nimble

@testable import ChatX

class LoginViewModelTest : QuickSpec {
    override func spec() {
        var viewModel: LoginViewModel!
        var scheduler: ConcurrentDispatchQueueScheduler!
        var isFormValidObservable: Observable<Bool>!
        
        beforeEach {
            viewModel = LoginViewModel()
            scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
            isFormValidObservable = viewModel.isFormValid.asObservable().subscribe(on: scheduler)
        }
        
        describe("filling login form") {
            context("with valid email and valid password") {
                it("so form should be valid") {
                    
                    viewModel.email.accept("test@mail.com")
                    viewModel.password.accept("password")
                    
                    expect(try isFormValidObservable.toBlocking(timeout: 1.0).first()).to(beTrue())
                }
            }
            
            context("with valid email and invalid password") {
                it("so form should be invalid") {
                    
                    viewModel.email.accept("test@mail.com")
                    viewModel.password.accept("pass")
                    
                    expect(try isFormValidObservable.toBlocking(timeout: 1.0).first()).to(beFalse())
                }
            }
            
            context("with invalid email and valid password") {
                it("so form should be invalid") {
                    
                    viewModel.email.accept("testmail.com")
                    viewModel.password.accept("password")
                    
                    expect(try isFormValidObservable.toBlocking(timeout: 1.0).first()).to(beFalse())
                }
            }
            
            context("with invalid email and invalid password") {
                it("so form should be invalid") {
                    
                    viewModel.email.accept("testmail.com")
                    viewModel.password.accept("pass")
                    
                    expect(try isFormValidObservable.toBlocking(timeout: 1.0).first()).to(beFalse())
                }
            }
        }
    }
}
