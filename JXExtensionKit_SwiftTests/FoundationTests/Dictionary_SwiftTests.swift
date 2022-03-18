//
//  Dictionary_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/4/13.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest

class Dictionary_SwiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let dic = ["string1":"字符串",
                    "integer1":(999),
                    "float1":(33.897),
                    "Bool1":(true),
                    "array1":["1","2","3"],
                    "dictionary1":["1":"1"],
                    "long1":999999999999999] as [String : Any]
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
