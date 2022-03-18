//
//  Array_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2021/3/31.
//  Copyright © 2021 Barnett. All rights reserved.
//

import Foundation

extension Array {
    
    /// NSIndex的数组重新排序
    func sortNSIndexArray() -> [Any]? {
        if self.isEmpty { return nil }
        let sorter = NSSortDescriptor.init(key: "section", ascending: true)
        let sorter1 = NSSortDescriptor.init(key: "row", ascending: true)
        let newArray = NSArray.init(array: self)
        let arr = newArray.sortedArray(using: [sorter,sorter1])
        return arr
    }
    /// 返回数组任意位置对象
    func randomObject() -> Any? {
        if self.isEmpty { return nil }
        let index : Int = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    /// 转化为json串
    /// - Returns: 字符串
   func jsonStringEncoded() -> String? {
        if self.isEmpty { return nil }
        if JSONSerialization.isValidJSONObject(self) {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
                return nil
            }
            let json = String.init(data: jsonData, encoding: .utf8)
            return json
        }
        return nil
    }
    
    /// 将数组序列化为二进制属性列表数据
    /// - Returns: data
    func plistData() -> Data? {
        if self.isEmpty { return nil }
        guard let data = try? PropertyListSerialization.data(fromPropertyList: self, format: .binary, options: .zero) else {
            return nil
        }
        return data
    }
}
