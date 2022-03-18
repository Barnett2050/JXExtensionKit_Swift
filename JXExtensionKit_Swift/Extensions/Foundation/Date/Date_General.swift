//
//  Date_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/29.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension Date {
    /// 年
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    /// 月
    func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    /// 日
    func day() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    /// 小时
    func hour() -> Int {
        return Calendar.current.component(.hour, from: self)
    }
    /// 分钟
    func minute() -> Int {
        return Calendar.current.component(.minute, from: self)
    }
    /// 秒
    func second() -> Int {
        return Calendar.current.component(.second, from: self)
    }
    /// 纳秒
    func nanosecond() -> Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
    /// 星期单位。范围为1-7 （一个星期有七天）
    func weekday() -> Int {
        return Calendar.current.component(.weekday, from: self)
    }
    /// 以7天为单位，范围为1-5 （1-7号为第1个7天，8-14号为第2个7天...）
    func weekdayOrdinal() -> Int {
        return Calendar.current.component(.weekdayOrdinal, from: self)
    }
    /// 当前月的周数
    func weekOfMonth() -> Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    /// 当前年的周数
    func weekOfYear() -> Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    /// 刻钟单位。范围为1-4 （1刻钟等于15分钟）
    func quarter() -> Int {
        return Calendar.current.component(.quarter, from: self)
    }
    
    /// 当前日期添加年，月，周，日，时，分，秒
    func dateByAddingYears(years : Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.year = years
        return calendar.date(byAdding: components, to: self)!
    }
    func dateByAddingMonths(months : Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.month = months
        return calendar.date(byAdding: components, to: self)!
    }
    func dateByAddingWeeks(weeks : Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents.init()
        components.weekOfYear = weeks
        return calendar.date(byAdding: components, to: self)!
    }
    func dateByAddingDays(days : Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(86400 * days)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    func dateByAddingHours(hours : Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(3600 * hours)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    func dateByAddingMinutes(minutes : Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(60 * minutes)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    func dateByAddingSeconds(seconds : Int) -> Date {
        let aTimeInterval = self.timeIntervalSinceReferenceDate + TimeInterval(seconds)
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return newDate
    }
    
    /// 获取本地时间戳，单位秒
    static func getLocalTimestamp() -> TimeInterval {
        let date = Date.init(timeIntervalSinceNow: 0)
        let time = date.timeIntervalSince1970
        return time
    }
    /// 与世界标准时间的时差
    static func getTimeDifferenceString() -> String? {
        let abbStr = TimeZone.current.abbreviation()
        return abbStr
    }
    /// 获取当前时区的差值
    static func getTimeDifferenceWithUTCTime() -> Double {
        let date = Date.init()
        let zone = TimeZone.current
        let time = zone.secondsFromGMT(for: date)
        let hourTime = Double(time) / 3600.0
        return hourTime
    }
    /// 计算相对现在的时间差，单位秒，大于0表示小于当前时间，小于0表示大于当前时间
    static func getTimeIntervalWithCurrent(date : Date) -> TimeInterval {
        let time = date.timeIntervalSince1970
        let nowDate = Date.init(timeIntervalSinceNow: 0)
        let currentTime = nowDate.timeIntervalSince1970
        return currentTime - time
    }
    /// 计算时间差(单位天)
    static func calculatedTimeDifferenceWith(startTime : TimeInterval,endTime : TimeInterval) -> Int {
        var sTime = startTime
        var eTime = endTime
        
        if (sTime > 140000000000) {
            sTime = sTime / 1000;
        }
        if (eTime > 140000000000) {
            eTime = eTime / 1000;
        }
        let seconds = fabs(eTime - sTime)
        let day = seconds / 60.0 / 60.0 / 24.0
        return Int(round(day))
    }
}
