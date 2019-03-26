//
//  CourseworkTests.swift
//  CourseworkTests
//
//  Created by Adam Simons on 06/02/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import XCTest
import Foundation
@testable import Coursework

class CourseworkTests: XCTestCase {
    func testCheckTextFieldTrue() {
        XCTAssertTrue(Utils.checkTextFieldComplete("Hello"))
    }
    func testCheckTextFieldFalse() {
        XCTAssertFalse(Utils.checkTextFieldComplete(""))
    }
    func testCheckDOBTextFieldTrue() {
        XCTAssertTrue(Utils.checkDOBTextField("21", noOfVals: 2))
    }
    func testCheckDOBTextFieldFalse() {
        XCTAssertFalse(Utils.checkDOBTextField("201", noOfVals: 2))
    }
    func testCheckEmailValidTrue() {
        XCTAssertTrue(Utils.checkEmailIsValid("14077485@students.southwales.ac.uk"))
    }
    func testCheckEmailValidFalse() {
        XCTAssertFalse(Utils.checkEmailIsValid("test"))
    }
    func testCheckDateValidTrue() {
        XCTAssertTrue(Utils.checkDateIsValid("01", "01", "2000") != nil)
    }
    func testCheckDateValidFalse() {
        XCTAssertFalse(Utils.checkDateIsValid("13", "32", "2000") != nil)
    }
    
    func testCheckLoginDetailsTrue() {
        XCTAssertTrue(Utils.checkLoginDetails("Admin", "password"))
    }
    func testCheckLoginDetailsFalse() {
        XCTAssertFalse(Utils.checkLoginDetails("admin", "password"))
    }
    func testCheckSubjectValidTrue() {
        XCTAssertTrue(Utils.checkSubjectIsValid("Dance"))
    }
    func testCheckSubjectValidFalse() {
        XCTAssertFalse(Utils.checkSubjectIsValid("Select Subject"))
    }
}
