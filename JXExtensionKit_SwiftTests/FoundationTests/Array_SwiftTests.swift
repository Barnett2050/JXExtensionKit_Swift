//
//  Array_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/3/30.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest

class Array_SwiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        var array : Array = ["1","2","3","4","5","6","5","4","3","2","1"]
        array = array.removeTheSameElement()
        XCTAssertTrue(array.count == 6)
        let newArray = array.safeSubarrayWithRange(0..<15) 
        XCTAssertTrue(newArray == array)
        
        let array2 = ["1","2","3","4","5","6"]
        print(array2.jsonStringEncoded() ?? "")
        print(array2.plistData() ?? "")
    }
}
