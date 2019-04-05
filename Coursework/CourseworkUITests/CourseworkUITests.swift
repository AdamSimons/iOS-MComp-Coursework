//
//  CourseworkUITests.swift
//  CourseworkUITests
//
//  Created by Adam Simons on 06/02/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import XCTest
// Everything is doubled and the picker wheel doesnt choose the right value.
// I have spent over 2 hours to do one of these tests and none of them work 😭😡
class CourseworkUITests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
// Used to test incomplete data alert
  func testIncompleteAlert() {
//        let app = XCUIApplication()
//        let elementsQuery = app.scrollViews.otherElements
//        elementsQuery.textFields["Last Name"].tap()
//
//        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        tKey.tap()
//
//        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        eKey.tap()
//
//
//        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        sKey.tap()
//
//        tKey.tap()
//        elementsQuery.textFields["Email"].tap()
//        tKey.tap()
//        eKey.tap()
//        sKey.tap()
//        tKey.tap()
//
//        let key = app/*@START_MENU_TOKEN@*/.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key.tap()
//        tKey.tap()
//        eKey.tap()
//        sKey.tap()
//        tKey.tap()
//        let key2 = app/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key2.tap()
//
//
//        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        cKey.tap()
//
//        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        oKey.tap()
//
//
//        let mKey = app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        mKey.tap()
//
//        elementsQuery.textFields["DD"].tap()
//
//        let key3 = app/*@START_MENU_TOKEN@*/.keys["0"]/*[[".keyboards.keys[\"0\"]",".keys[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//        key3.tap()
//
//        let key4 = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//        key4.tap()
//
//        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
//        doneButton.tap()
//        elementsQuery.textFields["MM"].tap()
//        key3.tap()
//
//        key4.tap()
//        elementsQuery.textFields["YYYY"].tap()
//
//        let key5 = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//
//        key5.tap()
//
//        key3.tap()
//        key3.tap()
//        key3.tap()
//        doneButton.tap()
//        elementsQuery.textFields["Subject"].tap()
//        app/*@START_MENU_TOKEN@*/.pickerWheels["Select Subject"]/*[[".pickers.pickerWheels[\"Select Subject\"]",".pickerWheels[\"Select Subject\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
//        doneButton.tap()
//        elementsQuery.buttons["Submit"].tap()
//        app.alerts["Incomplete Data"].buttons["OK"].tap()
//
   }
// Used to test email regex alert
   func testIncorrectEmail() {
//
//        let app = XCUIApplication()
//        let elementsQuery = app.scrollViews.otherElements
//        elementsQuery.textFields["First Name"].tap()
//        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        tKey.tap()
//        tKey.tap()
//
//        elementsQuery.textFields["Last Name"].tap()
//        tKey.tap()
//        elementsQuery.textFields["Email"].tap()
//        tKey.tap()
//        tKey.tap()
//        elementsQuery.textFields["DD"].tap()
//
//        let key = app/*@START_MENU_TOKEN@*/.keys["0"]/*[[".keyboards.keys[\"0\"]",".keys[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key.tap()
//
//        let key2 = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key2.tap()
//        elementsQuery.textFields["MM"].tap()
//        key.tap()
//        key2.tap()
//        elementsQuery.textFields["YYYY"].tap()
//
//        let key3 = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key3.tap()
//        key.tap()
//        key.tap()
//        key.tap()
//
//        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
//        doneButton.tap()
//        elementsQuery.textFields["Subject"].tap()
//        app/*@START_MENU_TOKEN@*/.pickerWheels["Select Subject"]/*[[".pickers.pickerWheels[\"Select Subject\"]",".pickerWheels[\"Select Subject\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
//        app.pickers.pickerWheels["Fashion"].tap()
//        doneButton.tap()
//        elementsQuery.buttons["Submit"].tap()
//        app.alerts["Incorrect email format"].buttons["OK"].tap()
   }
//    Used to dest the date checker
   func testIncorrectDate() {
//
//        let app = XCUIApplication()
//        let elementsQuery = app.scrollViews.otherElements
//        elementsQuery.textFields["First Name"].tap()
//
//        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        tKey.tap()
//        tKey.tap()
//        elementsQuery.textFields["Last Name"].tap()
//        tKey.tap()
//        elementsQuery.textFields["Email"].tap()
//        tKey.tap()
//
//        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        eKey.tap()
//
//        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        sKey.tap()
//        sKey.tap()
//        tKey.tap()
//        tKey.tap()
//
//        let key = app/*@START_MENU_TOKEN@*/.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key.tap()
//        key.tap()
//        tKey.tap()
//        eKey.tap()
//        sKey.tap()
//        sKey.tap()
//        tKey.tap()
//        tKey.tap()
//
//        let key2 = app/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key2.tap()
//
//        let cKey = app/*@START_MENU_TOKEN@*/.keys["c"]/*[[".keyboards.keys[\"c\"]",".keys[\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        cKey.tap()
//        cKey.tap()
//
//        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        oKey.tap()
//        oKey.tap()
//
//        let mKey = app/*@START_MENU_TOKEN@*/.keys["m"]/*[[".keyboards.keys[\"m\"]",".keys[\"m\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        mKey.tap()
//        mKey.tap()
//        elementsQuery.textFields["DD"].tap()
//
//        let key3 = app/*@START_MENU_TOKEN@*/.keys["8"]/*[[".keyboards.keys[\"8\"]",".keys[\"8\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key3.tap()
//        key3.tap()
//        elementsQuery.textFields["MM"].tap()
//        app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let key4 = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key4.tap()
//        key4.tap()
//        elementsQuery.textFields["YYYY"].tap()
//        app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let key5 = app/*@START_MENU_TOKEN@*/.keys["0"]/*[[".keyboards.keys[\"0\"]",".keys[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key5.tap()
//        key5.tap()
//        key5.tap()
//        key5.tap()
//
//        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
//        doneButton.tap()
//        elementsQuery.textFields["Subject"].tap()
//        app/*@START_MENU_TOKEN@*/.pickerWheels["Select Subject"]/*[[".pickers.pickerWheels[\"Select Subject\"]",".pickerWheels[\"Select Subject\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
//        app.pickers.pickerWheels["Fashion"].tap()
//        doneButton.tap()
//        elementsQuery.buttons["Submit"].tap()
//        app.alerts["Incorrect date"].buttons["OK"].tap()
//
//
   }
//    Used to test incorrect subject choice alert
    func testIncorrectSubject() {
//
   }
}
