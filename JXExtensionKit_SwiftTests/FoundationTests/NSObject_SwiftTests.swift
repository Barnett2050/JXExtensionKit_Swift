//
//  NSObject_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/8/2.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest

@objcMembers class TestModel: NSObject {
    dynamic var name : String = "test"
    var age : Int = 9
    var girl : Bool = false
    
    func run() -> Void {
        print("奔跑")
    }
}

class NSObject_SwiftTests: XCTestCase {

    var title : String? = nil
    var count : Int = 0
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_General() throws {
        TestModel.printClassMethodList()
        TestModel.printClassPropertyList()
        TestModel.printCustomClassPropertyList()
        let model = TestModel.init()
        print(model.properties_mapDictionary() ?? "")
        
    }
    
    func test_KVO() throws {
        let model = TestModel.init()
        model.addObserverBlockForKeyPath("name") { obj, oldValue, newValue in
            print(obj ?? "")
            print("oldValue:" + (oldValue as! String))
            print("newValue:" + (newValue as! String))
        }
        model.name = "test2"
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
