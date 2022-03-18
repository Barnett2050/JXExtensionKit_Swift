//
//  Bundle_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/3/24.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest

class Bundle_SwiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertTrue(Bundle.getApplicationName() == "JXExtensionKit_Swift")
        XCTAssertTrue(Bundle.getApplicationVersion() == "1.0")
        XCTAssertTrue(Bundle.getBundleID() == "com.qwbcg.JXExtensionKit-Swift")
        XCTAssertTrue(Bundle.getBuildVersion() == "1")
        XCTAssertTrue(Bundle.currentAppVersionIsUpdateWith(newVersion: "2.0.0"))
    }

}
