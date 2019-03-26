//
//  CourseworkUITests.swift
//  CourseworkUITests
//
//  Created by Adam Simons on 06/02/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import XCTest

class CourseworkUITests: XCTestCase {
    func testEmailValid() {
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["First Name"].tap()
        elementsQuery.children(matching: .textField).element(boundBy: 1).tap()
        elementsQuery.children(matching: .textField).element(boundBy: 2).tap()
        elementsQuery.textFields["DD"].tap()
        elementsQuery.textFields["MM"].tap()
        elementsQuery.textFields["YYYY"].tap()
        elementsQuery.children(matching: .textField).element(boundBy: 6).tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Accounting & Finance"]/*[[".pickers.pickerWheels[\"Accounting & Finance\"]",".pickerWheels[\"Accounting & Finance\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        elementsQuery.buttons["Submit"].tap()

    
    }
}
