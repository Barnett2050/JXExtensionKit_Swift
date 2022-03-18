//
//  Data_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/3/11.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest
import Foundation

class Data_SwiftTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    var testString = "1234567890"
    let encryptKey = "20200429"
    
    let aesKey = "0123456789111213"
    let testIv = "0123456789111213"
    
    func test_Encrypt() throws {
        var testData = self.testString.data(using: String.Encoding.utf8)
        
        XCTAssertTrue(testData!.md2String() == "38e53522a2e67fc5ea57bae1575a3107")
        XCTAssertTrue(testData!.md4String() == "85b196c3e39457d91cab9c905f9a11c0")
        XCTAssertTrue(testData!.md5String() == "e807f1fcf82d132f9bb018ca6738a19f")
        XCTAssertTrue(testData!.sha1String() == "01b307acba4f54f55aafc33bb06bbbf6ca803e9a")
        XCTAssertTrue(testData!.sha224String() == "b564e8a5cf20a254eb34e1ae98c3d957c351ce854491ccbeaeb220ea")
        XCTAssertTrue(testData!.sha256String() == "c775e7b757ede630cd0aa1113bd102661ab38829ca52a6422ab782862f268646")
        XCTAssertTrue(testData!.sha384String() == "ed845f8b4f2a6d5da86a3bec90352d916d6a66e3420d720e16439adf238f129182c8c64fc4ec8c1e6506bc2b4888baf9")
        XCTAssertTrue(testData!.sha512String() == "12b03226a6d8be9c6e8cd5e55dc6c7920caaa39df14aab92d5e3ea9340d1c8a4d3d0b8e4314f1f6ef131ba4bf1ceb9186ab87c801af0d5c95b1befb8cedae2b9")
        
        XCTAssertTrue(testData!.hmacMD5StringWithKey(self.encryptKey) == "01de3e2062a1d46209dbef9a685e19c8")
        XCTAssertTrue(testData!.hmacSHA1StringWithKey(self.encryptKey) == "571a9d96fa688df2a51edf57086d0d0b5fd36e3c")
        XCTAssertTrue(testData!.hmacSHA224StringWithKey(self.encryptKey) == "70c549ba7c953b0e48fd30d6cf384a9004fffd79dfdf01cfc0dcc537")
        XCTAssertTrue(testData!.hmacSHA256StringWithKey(self.encryptKey) == "bf14cf26fd5beafd9575a764158ae03cb6a5b6fbb72492bdb2052e8ff1e4a721")
        XCTAssertTrue(testData!.hmacSHA384StringWithKey(self.encryptKey) == "cb68513d18860e62143de511c747ce5651c5aace9112b672544020099337638dd2bad3ad2de85d8d9029d53e6127e2ee")
        XCTAssertTrue(testData!.hmacSHA512StringWithKey(self.encryptKey) == "6f56ee663fea8497d6912d867b3d7c6cab5c4a8bae7908a59217fd1765836019013ab914d64a440c09eaddc187796a6bdcfc4175ffbf722984c085f432e0b813")
        
        testString = "一段测试转换文字"
        testData = testString.data(using: String.Encoding.utf8)
        
        XCTAssertTrue(testData!.utf8String() == self.testString)

        XCTAssertTrue(testData!.hexString() == "E4B880E6AEB5E6B58BE8AF95E8BDACE68DA2E69687E5AD97")
        XCTAssertTrue(testData!.base64EncodedString() == "5LiA5q615rWL6K+V6L2s5o2i5paH5a2X")
        
        let jsonDic = ["name":"Test"]
        let jsonData : Data = try JSONSerialization.data(withJSONObject: jsonDic, options: JSONSerialization.WritingOptions.prettyPrinted)
        print(jsonData.jsonValueDecoded() as Any)
    }
    
    func test_General() throws {
        var data = Bundle.mainBundleData(name: "test", type: "jpg")
        var gzipData = data!.gzippedData()
        XCTAssertTrue(gzipData!.isGzippedData(),"gzip压缩")
        XCTAssertTrue(data!.gzippedDataWithCompressionLevel(0.9)!.isGzippedData(),"gzip压缩")
        XCTAssertTrue(gzipData?.gunzippedData() == data,"gzip解压缩")
        print("=====" + gzipData!.description)
        print("=====" + data!.gzippedDataWithCompressionLevel(0)!.description)
    }
}
