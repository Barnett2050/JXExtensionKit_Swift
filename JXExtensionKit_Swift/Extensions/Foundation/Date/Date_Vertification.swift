//
//  Date_Vertification.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/29.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension Date {
    
    /// 当前日期是否为今天
    func isToday() -> Bool {
        if fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24 {
            return false
        }
        let day = Calendar.current.component(.day, from: self)
        let nowDay = Calendar.current.component(.day, from: Date.init())
        return day == nowDay
    }
    /// 当前日期是否为昨天
    func isYesterday() -> Bool {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + 86400
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate.isToday()
    }
    /// 两个日期是否为相同一天
    static func isSameDay(oneDate:Date,anotherDate:Date) -> Bool {
        let calendar = Calendar.current
        let unitFlags : Set = [Calendar.Component.year,Calendar.Component.month,Calendar.Component.day]
        
        let compOne = calendar.dateComponents(unitFlags, from: oneDate)
        let compAnother = calendar.dateComponents(unitFlags, from: anotherDate)
        
        let flag = compOne.year == compAnother.year && compOne.month == compAnother.month && compOne.day == compAnother.day
        return flag
    }
    
    /// 时间的早晚比较
    /// - Parameters:
    ///   - oneTime: 时间戳字符串，时间字符串
    ///   - anotherTime: 时间戳字符串，时间字符串
    ///   - format: 传入format为nil时比较时间字符串，有相应值时比较时间戳字符串
    /// - Returns: 比较结果，数组为从小到大排序
    static func compareTwoTimes(_ oneTime : String?,_ anotherTime : String?,format : String?) -> (comparisionResult : ComparisonResult?,resultArray : Array<String>?) {
        if oneTime?.isEmpty ?? true || anotherTime?.isEmpty ?? true {
            return (nil,nil)
        }
        if format != nil && format!.count > 0 {
            let formatter = DateFormatter.init()
            formatter.dateFormat = format!
            let oneDate = formatter.date(from: oneTime!)
            let anotherDate = formatter.date(from: anotherTime!)
            let result = oneDate?.compare(anotherDate ?? Date.init())
            var array = Array<String>.init()
            
            switch result {
            case .orderedAscending,.orderedSame:
                array = [oneTime!,anotherTime!]
                break
            case .orderedDescending:
                array = [anotherTime!,oneTime!]
                break
            default: break
            }
            return (result,array)
        } else {
            var oneTimeInterval = TimeInterval(oneTime!)!
            var anotherTimeInterval = TimeInterval(anotherTime!)!
            if oneTimeInterval > 140000000000 {
                oneTimeInterval = oneTimeInterval / 1000
            }
            if anotherTimeInterval > 140000000000 {
                anotherTimeInterval = anotherTimeInterval / 1000
            }
            var array = Array<String>.init()
            var comparisionResult = ComparisonResult.orderedDescending
            if oneTimeInterval > anotherTimeInterval {
                array = [anotherTime!,oneTime!]
            } else if oneTimeInterval == anotherTimeInterval {
                comparisionResult = .orderedSame
                array = [oneTime!,anotherTime!]
            } else {
                comparisionResult = .orderedAscending
                array = [oneTime!,anotherTime!]
            }
            return (comparisionResult,array)
        }
    }
}
