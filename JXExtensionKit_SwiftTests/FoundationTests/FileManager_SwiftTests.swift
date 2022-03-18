//
//  FileManager_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/4/13.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest

class FileManager_SwiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_data() throws {
        let path = Bundle.main.path(forResource: "test", ofType: "jpg") ?? ""
        print("文件的大小：\(String(describing: FileManager.fileSizeStringAtPath(path)))")
        
        let writeString = "一段输入的代码，进行输入操作"
        FileManager.writeDataToSharedDocumentsWith(data: writeString.data(using: .utf8)!, directory: "JXData", fileName: "test.text") { (isSuccess) in
            XCTAssertTrue(isSuccess,"写入失败")
        }
        
        let filePath = FileManager.filePathAt(pathType: .DocumentPathType, fileName: "test2.text", isCreat: true)
        for i in 0..<1000 {
            autoreleasepool {
                let content = String.init(format: "%ld", i)
                FileManager.writeDataToFile(filePath, data: content.data(using: .utf8)!)
            }
            if i == 999 {
                print("写入完毕")
            }
        }
    }

    func test_filePath() throws {
        print("libraryDirectory : \(FileManager.pathForSystemFile(directory: .libraryDirectory) ?? "")")
        print("fileName : \(FileManager.filePathForSystemFile(directory: .documentDirectory, fileName: "test1"))")
        print("DocumentPathType : \(FileManager.directoryPathFor(pathType: .DocumentPathType) ?? "")")
        print("CachesPathType : \(FileManager.directoryPathFor(pathType: .CachesPathType) ?? "")")
        print("PreferencesPathType : \(FileManager.directoryPathFor(pathType: .PreferencesPathType) ?? "")")
        print("TempPathType : \(FileManager.directoryPathFor(pathType: .TempPathType) ?? "")")
        print("BundlePathType : \(FileManager.directoryPathFor(pathType: .BundlePathType) ?? "")")
        
        let test2 = FileManager.filePathAt(pathType: .DocumentPathType, fileName: "test2.text", isCreat: true)
        print("test2 : \(test2)")
        XCTAssertTrue(FileManager.fileIsExists(test2))
        
        let test3 = FileManager.filePathAt(pathType: .CachesPathType, fileName: "test3.text", isCreat: true)
        print("test3 : \(test3)")
        XCTAssertTrue(FileManager.fileIsExists(test3))
        
        let test4 = FileManager.filePathAt(pathType: .PreferencesPathType, fileName: "test4.text", isCreat: true)
        print("test4 : \(test4)")
        XCTAssertTrue(FileManager.fileIsExists(test4))
        
        let test5 = FileManager.filePathAt(pathType: .TempPathType, fileName: "test5.text", isCreat: true)
        print("test5 : \(test5)")
        XCTAssertTrue(FileManager.fileIsExists(test5))
        
        let test6 = FileManager.filePathAt(pathType: .BundlePathType, fileName: "test6.text", isCreat: true)
        print("test6 : \(test6)")
        XCTAssertTrue(FileManager.fileIsExists(test6))
        
        let test7 = FileManager.directoryPathAt(pathType: .DocumentPathType, directoryName: "test7", isCreat: true)
        print("test7 : \(test7)")
        XCTAssertTrue(FileManager.fileIsExists(test7))
        
        let test8 = FileManager.directoryPathAt(pathType: .CachesPathType, directoryName: "test8", isCreat: true)
        print("test8 : \(test8)")
        XCTAssertTrue(FileManager.fileIsExists(test8))
        
        let test9 = FileManager.directoryPathAt(pathType: .PreferencesPathType, directoryName: "test9", isCreat: true)
        print("test9 : \(test9)")
        XCTAssertTrue(FileManager.fileIsExists(test9))
        
        let test10 = FileManager.directoryPathAt(pathType: .TempPathType, directoryName: "test10", isCreat: true)
        print("test10 : \(test10)")
        XCTAssertTrue(FileManager.fileIsExists(test10))
        
        let test11 = FileManager.directoryPathAt(pathType: .BundlePathType, directoryName: "test11", isCreat: true)
        print("test11 : \(test11)")
        XCTAssertTrue(FileManager.fileIsExists(test11))
    }
    
    func test_verification() throws {
        let filePath = FileManager.filePathAt(pathType: .DocumentPathType, fileName: "test2.text", isCreat: true)
        XCTAssertTrue(FileManager.isTimeoutWithPath(filePath, timeout: 10),"文件创建超过设定时间")
        
        let filePath3 = FileManager.filePathAt(pathType: .CachesPathType, fileName: "test3.text", isCreat: true)
        XCTAssertTrue(FileManager.removeFileWithPath(filePath3))
        
        let filePath10 = FileManager.filePathAt(pathType: .TempPathType, fileName: "test10.text", isCreat: true)
        XCTAssertFalse(FileManager.isDirectory(filePath10))
        
        let filePath11 = FileManager.filePathAt(pathType: .DocumentPathType, fileName: "test11.text", isCreat: false)
        XCTAssertTrue(FileManager.moveItemAtPath(filePath10, dstPath: filePath11))
        
        let filePath12 = FileManager.filePathAt(pathType: .DocumentPathType, fileName: "test12.text", isCreat: true)
        XCTAssertTrue(FileManager.resetFinderWithPath(filePath12))
    }
}
