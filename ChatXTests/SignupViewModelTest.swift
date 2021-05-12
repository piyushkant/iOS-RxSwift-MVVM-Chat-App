////
////  SignupViewModelTest.swift
////  ChatXTests
////
////  Created by Piyush Kant on 2021/05/12.
////
//
//import XCTest
//import RxSwift
//import RxCocoa
//import RxTest
//import RxBlocking
//
//@testable import ChatX
//
//class SignupViewModelTest : XCTestCase {
//    var viewModel: SignupViewModel!
//    var scheduler: ConcurrentDispatchQueueScheduler!
//    
//    override func setUp() {
//        super.setUp()
//        
//        viewModel = SignupViewModel()
//        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
//    }
//    
//    func testSignupForm_WhenAllInputsAreValid_formShouldBeValid() throws {
//        let isFormValidObservable = viewModel.isFormValid.asObservable().subscribe(on: scheduler)
//        
//        viewModel.profileImage.accept(UIImage(named: "AppLogo"))
//        viewModel.email.accept("test@mail.com")
//        viewModel.password.accept("password")
//        viewModel.fullName.accept("fullname")
//        viewModel.userName.accept("usernme")
//        
//        XCTAssertEqual(try isFormValidObservable.toBlocking(timeout: 1.0).first(), true)
//    }
//}
