//
//  Data_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension Data {
    /// 从main bundle获取文件数据
    /// - Parameters:
    ///   - name: 文件名称（在main bundle）
    ///   - type: 文件后缀名
    static func mainBundleDataNamed(_ name : String?,type : String?) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: type)
        if path == nil { return nil }
        guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!)) else {
            return nil;
        }
        return data
    }
    
    /// Data转十六进制String
    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
                .joined(separator: "")
    }
}
