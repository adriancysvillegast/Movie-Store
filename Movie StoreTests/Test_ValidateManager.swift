//
//  Test_ValidateManager.swift
//  Movie StoreTests
//
//  Created by Adriancys Jesus Villegas Toro on 27/2/24.
//

import XCTest
@testable import Movie_Store


final class Test_ValidateManager: XCTestCase {
    
    var sut: ValidateManager!
    
    override func setUpWithError() throws {
        sut = ValidateManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_validateNameDidError() {
        let name = " "
        let result = sut.validateName(nameUser: name)
        XCTAssertFalse(result)
    }

    func test_validateNameDidSuccess() {
        let name = "Adrian"
        let result = sut.validateName(nameUser: name)
        XCTAssertTrue(result)
    }

    func test_validateEmailDidError() {
        let email = "sjsf@jsfj"
        let result = sut.validateEmail(emailUser: email)
        XCTAssertFalse(result)
    }
    
    func test_validateEmailDidSuccess() {
        let email = "test@gmail.com"
        let result = sut.validateEmail(emailUser: email)
        XCTAssertTrue(result)
    }
    
    func test_validatePasswordDidError() {
        let password = " "
        let result = sut.validatePassword(passwordUser: password)
        XCTAssertFalse(result)
    }
    
    func test_validatePasswordDidSuccess() {
        let password = "Awf12**"
        let result = sut.validatePassword(passwordUser: password)
        XCTAssertTrue(result)
    }
    
}
