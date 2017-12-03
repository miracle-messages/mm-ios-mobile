//
//  MiracleMsgUITests.swift
//  MiracleMsgUITests
//
//  Created by Win Raguini on 2/20/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import XCTest

class MiracleMsgUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        snapshot("01LoginScreen")
        let fullNameTextField = app.textFields["Full Name"]
        fullNameTextField.tap()
        fullNameTextField.typeText("W")
        fullNameTextField.typeText("in")
        fullNameTextField.typeText("fred")


        app.buttons["Return"].tap()




        // Use recording to get started writing UI tests.
        
        
    }
    
}
