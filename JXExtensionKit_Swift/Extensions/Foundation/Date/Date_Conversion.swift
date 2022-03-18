//
//  Date_Conversion.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/21.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension Date {
    
    /// 根据日期格式Date转时间字符串
    /// - Parameter format: 日期格式
    func getDateTimeStringWithformat(_ format : String) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        let currentDate = dateFormatter.string(from: self)
        return currentDate
    }
    
    //    MARK:NSDate
    /// 根据日期格式获取系统时间
    /// - Parameter format: 日期格式
    /// - Returns: 日期
    static func getSystemDateTimeWithFormat(_ format : String) -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        let dateStr = formatter.string(from: Date.init())
        return dateStr
    }
    
    /// 根据日期格式时间字符串转Date
    /// - Parameters:
    ///   - string: 时间字符串
    ///   - format: 格式
    static func getDateFromDateString(_ string : String?,format : String) -> Date? {
        if string == nil {
            return nil
        }
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        let date = formatter.date(from: string!)
        return date
    }
    
    /// 根据日期格式转化时间戳(UTC)
    /// - Parameters:
    ///   - timestamp: 时间戳,秒，毫秒均可
    ///   - format: 时间格式
    static func getDateTimeStringFromTimestamp(_ timestamp : TimeInterval,format : String) -> String {
        let isMilliSecond = timestamp > 140000000000
        var time : TimeInterval = 0.0
        if isMilliSecond {
            time = timestamp / 1000
        }
        let date = Date.init(timeIntervalSince1970: time)
        let formatter = DateFormatter.init()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    /// 根据日期格式转化时间戳字符串(UTC)
    /// - Parameters:
    ///   - timestamp: 时间戳字符串
    ///   - format: 时间格式
    static func getDateTimeStringFromTimestampString(_ timestamp:String?,format : String) -> String? {
        if timestamp == nil {
            return nil
        }
        let time = TimeInterval.init(timestamp!)
        return Date.getDateTimeStringFromTimestamp(time!, format: format)
    }
    
    /// 根据日期格式转化时间字符串为时间戳(UTC)
    /// - Parameters:
    ///   - timeStr: 时间字符串
    ///   - format: 时间格式
    ///   - isMilliSecond: 是否为毫秒
    static func getTimestampFromString(_ timeStr : String?,format : String,isMilliSecond : Bool) -> TimeInterval? {
        if timeStr == nil {
            return nil
        }
        let date = self.p_dateFromString(timeStr!, format: format)
        var time : TimeInterval = date!.timeIntervalSince1970
        if isMilliSecond {
            time = date!.timeIntervalSince1970 * 1000
        }
        return time
    }
    
    /// 时间戳转n小时、分钟、秒前 或者yyyy-MM-dd HH:mm:ss
    /// - Parameter timestamp: 时间戳
    static func getBeforeTimeFromTimestamp(_ timestamp : String?) -> String? {
        if timestamp == nil {
            return nil
        }
        let time = Double.init(timestamp!)!
        let isMilliSecond = time > 140000000000
        var date = Date.init()
        if isMilliSecond {
            date = Date.init(timeIntervalSince1970: time/1000)
        } else {
            date = Date.init(timeIntervalSince1970: time)
        }
        var strBefore = ""
        let interval = Int(abs(date.timeIntervalSinceNow))
        let nDay = interval / (60 * 60 * 24)
        let nHour = interval / (60 * 60)
        let nMin = interval / 60
        let nSec = interval
        
        if nDay >= 1 {
            let df = DateFormatter.init()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            strBefore = df.string(from: date)
        } else if nHour >= 1 {
            strBefore = String.init(format: "%li小时前", nHour)
        } else if nMin >= 1 {
            strBefore = String.init(format: "%li分钟前", nMin)
        } else if nSec >= 1 {
            strBefore = String.init(format: "%li秒前", nSec)
        } else {
            strBefore = "刚刚"
        }
        return strBefore
    }
    
    /// 将秒根据格式转换，限于时分秒
    /// - Parameters:
    ///   - totalSecond: 秒
    ///   - format: 格式,h小时 m分钟 s秒，hh代表不够补零,默认hh:mm:ss
    static func getHHMMSSFromSS(totalSecond : Int,format : String?) -> String {
        if totalSecond <= 0 {
            return ""
        }
        var formatStr = ""
        if format == nil {
            formatStr = "hh:mm:ss"
        } else {
            formatStr = format!.lowercased()
        }
        let seconds = totalSecond % 60
        let minutes = (totalSecond / 60) % 60
        let hours = ((totalSecond / 60) / 60) % 24
        
        // format of hour
        if formatStr.contains("hh") {
            let content = String.init(format: "%02ld", hours)
            formatStr = formatStr.replacingOccurrences(of: "hh", with: content)
        } else if formatStr.contains("h") {
            let content = String.init(format: "%ld", hours)
            formatStr = formatStr.replacingOccurrences(of: "h", with: content)
        }
        // format of minute
        if formatStr.contains("mm") {
            let content = String.init(format: "%02ld", minutes)
            formatStr = formatStr.replacingOccurrences(of: "mm", with: content)
        } else if formatStr.contains("m") {
            let content = String.init(format: "%ld", minutes)
            formatStr = formatStr.replacingOccurrences(of: "m", with: content)
        }
        // format of second
        if formatStr.contains("ss") {
            let content = String.init(format: "%02ld", seconds)
            formatStr = formatStr.replacingOccurrences(of: "ss", with: content)
        } else if formatStr.contains("s") {
            let content = String.init(format: "%ld", seconds)
            formatStr = formatStr.replacingOccurrences(of: "s", with: content)
        }
        return formatStr
    }
    
    /// 时间戳根据格式返回数据 HH:mm / 昨天 HH:mm / MM月dd日 HH:mm / yyyy年MM月dd日
    /// - Parameter timestamp: 时间戳字符串
    static func getVariableFormatDateStringFromTimestamp(_ timestamp : String?) -> String? {
        if timestamp == nil {
            return nil
        }
        let time = Double.init(timestamp!)!
        let isMilliSecond = time > 140000000000
        var date = Date.init()
        if isMilliSecond {
            date = Date.init(timeIntervalSince1970: time/1000)
        } else {
            date = Date.init(timeIntervalSince1970: time)
        }
        let formatter = DateFormatter.init()
        if Date.p_isToday(date: date) {
            formatter.dateFormat = "HH:mm"
        } else if (Date.p_isYesterday(date: date)) {
            formatter.dateFormat = "昨天 HH:mm"
        } else if (Date.p_isSameYear(date1: Date.init(), date2: date)) {
            formatter.dateFormat = "M月dd日 HH:mm"
        } else {
            formatter.dateFormat = "yyyy年M月dd日"
        }
        return formatter.string(from: date)
        
    }
    
    //    MARK:NSCalendar
    /// 时间戳UTC转换为本地时间，例：几分钟前，几小时前，几天前，几月前，几年前
    /// - Parameter timestamp: 时间戳
    static func getLocalPopularTimeFromTimestamp(_ timestamp : String?) -> String? {
        if timestamp == nil {
            return nil
        }
        var value = Double.init(timestamp!)!
        let isMilliSecond = value > 140000000000
        if isMilliSecond {
            value = value / 1000
        }
        let date = Date.init(timeIntervalSinceNow: 0)
        let time = date.timeIntervalSince1970
        if time <= value {
            return "刚刚"
        }
        let expireDate = Date.init(timeIntervalSince1970: value)
        let nowDate = Date.init()
        let calendar = Calendar.current
        let unit : Set<Calendar.Component> = [.year,.month,.day,.hour,.minute,.second]
        let dateCom = calendar.dateComponents(unit, from: nowDate, to: expireDate)
        
        var returnStr = ""
        let year = abs(dateCom.year ?? 0)
        let month = abs(dateCom.month ?? 0)
        let day = abs(dateCom.day ?? 0)
        let hour = abs(dateCom.hour ?? 0)
        let minute = abs(dateCom.minute ?? 0)
        
        if year != 0 {
            returnStr = String.init(format: "%d年前", year)
        } else if month != 0 {
            returnStr = String.init(format: "%d月前", month)
        } else if day != 0 {
            returnStr = String.init(format: "%d天前", day)
        } else if hour != 0 {
            returnStr = String.init(format: "%d小时前", hour)
        } else if minute > 1 && minute < 60 {
            returnStr = String.init(format: "%d分钟前", minute)
        } else {
            returnStr = "刚刚"
        }
        return returnStr
    }
    
    //    MARK:private
    static private func p_dateFromString(_ timeStr : String,format : String) -> Date? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: timeStr)
        return date
    }
    static private func p_isToday(date : Date) -> Bool {
        if fabs(date.timeIntervalSinceNow) >= 60 * 60 * 24 {
            return false
        }
        let day = Calendar.current.component(.day, from: date)
        let nowDay = Calendar.current.component(.day, from: Date.init())
        return day == nowDay
    }
    static private func p_isYesterday(date : Date) -> Bool {
        let aTimeInterval = date.timeIntervalSinceReferenceDate + 86400
        let newDate = Date.init(timeIntervalSinceReferenceDate: aTimeInterval)
        return Date.p_isToday(date: newDate)
    }
    static private func p_isSameYear(date1 : Date,date2 : Date) -> Bool {
        let year1 = Calendar.current.component(.year, from: date1)
        let year2 = Calendar.current.component(.year, from: date2)
        return year1 == year2
    }
}
