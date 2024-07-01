//
//  Test_AuthManager.swift
//  Movie StoreTests
//
//  Created by Adriancys Jesus Villegas Toro on 23/2/24.
//

import XCTest
@testable import Movie_Store

final class Test_AuthManager: XCTestCase {

    var sut: AuthManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = AuthManager()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func test_createAccountDidError() {
        let email = ""
        let password = ""
        let username = ""
        
        sut.createNewUser(email: email, password: password) { result in
            XCTAssertFalse(result)
        }
    }
    
    func test_createAccountDidSuccess() {
//      change all properties to get a correct result
        let email = "Testing@gmail.com"
        let password = "testing123*"
        let username = "testing"
        
        sut.createNewUser(email: email, password: password) { result in
            XCTAssertTrue(result)
        }
    }

    func test_logInDidError() {
//        used any values
        let email = "1234de@gmail.com"
        let password = "testing123*"
        
        sut.logIn(email: email, password: password) { result in
            XCTAssertTrue(result)
        }
        
    }
    
    func test_logInDidSuccess() {
//        Copy and used the same value of the methods "test_createAccountDidSuccess"
        let email = "Testing@gmail.com"
        let password = "testing123*"
        let username = "testing"
        
        sut.logIn(email: email, password: password) { result in
            XCTAssertTrue(result)
        }
        
    }
    
    

}
