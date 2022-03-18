//
//  Array_Safe.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2021/3/25.
//  Copyright © 2021 Barnett. All rights reserved.
//

import Foundation

extension Array where Element : Hashable {
    
    /// 去除重复元素
    func removeTheSameElement() -> Array<Element> {
        if self.isEmpty {
            return self
        }
        let newSet = Set(self)
        let newArray = Array(newSet)
        return newArray
    }
    /// 安全取值
    func safeObjectAtIndex(_ index : Int) -> Element? {
        if self.isEmpty || index > self.count {
            return nil
        }
        return self[index]
    }
    // 取一段数组
    func safeSubarrayWithRange(_ range : Range<Int>) -> Array<Element>? {
        return Array(self[self.getNewRangeWith(range, count: self.count)])
    }
    //    MARK: private 
    private func getNewRangeWith(_ range : Range<Int>,count : Int) -> Range<Int> {
        let location = range.startIndex
        var length = range.count
        if location > count {
            return location..<location
        } else {
            if length + location > count {
                length = count - location
            }
            return location..<length
        }
    }
}


