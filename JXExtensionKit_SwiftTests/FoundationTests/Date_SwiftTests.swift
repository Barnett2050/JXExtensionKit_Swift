//
//  Date_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/4/12.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest

class Date_SwiftTests: XCTestCase {
    
    let currentTimeInterval : TimeInterval = 1615182888000
    let currentDateString = "2021-03-08 PM 13:54:48 Monday"
    let currentDate = Date.init(timeIntervalSince1970: 1615182888)
    
    let descendingTimeInterval : TimeInterval = 1615097111000
    let descendingDateString = "2021-03-07 PM 14:05:11 Monday"
    let descendingDate = Date.init(timeIntervalSince1970: 1615097111)
    
    let ascendingTimeInterval : TimeInterval = 1615097111000
    let ascendingDateString = "2021-03-07 PM 14:05:11 Monday"
    let ascendingDate = Date.init(timeIntervalSince1970: 1615097111)
    
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_coversion() throws {
        let current = Date.getSystemDateTimeWithFormat("yyyy-MM-dd a HH:mm:ss EEEE")
        print(current)
        
        let date = Date.getDateFromDateString(self.currentDateString, format: "yyyy-MM-dd a HH:mm:ss EEEE")
        XCTAssertTrue(date != nil && date == self.currentDate)
        
        let timeString = Date.getDateTimeStringFromTimestampString("1615182888000", format: "yyyy-MM-dd a HH:mm:ss EEEE")
        XCTAssertTrue(timeString != nil && timeString == self.currentDateString)
        
        let timestamp = Date.getTimestampFromString(self.currentDateString, format: "yyyy-MM-dd a HH:mm:ss EEEE", isMilliSecond: true)
        XCTAssertTrue(timestamp != nil && timestamp == self.currentTimeInterval)
        
        var timeInterval = Date.init().timeIntervalSince1970
        let timeIntervalString1 = String.init(format: "%f", timeInterval)
        XCTAssertTrue((Date.getBeforeTimeFromTimestamp(timeIntervalString1) != nil) && Date.getBeforeTimeFromTimestamp(timeIntervalString1) == "刚刚")
        
        let timeIntervalString2 = String.init(format: "%f", timeInterval - 30)
        XCTAssertTrue((Date.getBeforeTimeFromTimestamp(timeIntervalString2) != nil) && Date.getBeforeTimeFromTimestamp(timeIntervalString2) == "30秒前")
        
        let timeIntervalString3 = String.init(format: "%f", timeInterval - 300)
        XCTAssertTrue((Date.getBeforeTimeFromTimestamp(timeIntervalString3) != nil) && Date.getBeforeTimeFromTimestamp(timeIntervalString3) == "5分钟前")
        
        let timeIntervalString4 = String.init(format: "%f", timeInterval - 7200)
        XCTAssertTrue((Date.getBeforeTimeFromTimestamp(timeIntervalString4) != nil) && Date.getBeforeTimeFromTimestamp(timeIntervalString4) == "2小时前")
        
        let secondString1 = Date.getHHMMSSFromSS(totalSecond: 3596, format: nil)
        let secondString2 = Date.getHHMMSSFromSS(totalSecond: 3546, format: "mm:ss")
        let secondString3 = Date.getHHMMSSFromSS(totalSecond: 3546, format: "m:s")
        XCTAssertTrue(secondString1 == "00:59:56")
        XCTAssertTrue(secondString2 == "59:06")
        XCTAssertTrue(secondString3 == "59:6")
        
        
        var timestampString = String.init(format: "%.f", timeInterval)
        var currentDate = Date.init()
        var formatter = DateFormatter.init()
        formatter.dateFormat = "HH:mm"
        XCTAssertTrue(Date.getVariableFormatDateStringFromTimestamp(timestampString) == formatter.string(from: currentDate))
        XCTAssertTrue(Date.getLocalPopularTimeFromTimestamp(timestampString) == "刚刚")
        
        timeInterval = timeInterval - 60 * 60 * 25
        timestampString = String.init(format: "%.f", timeInterval)
        currentDate = Date.init(timeIntervalSince1970: timeInterval)
        formatter = DateFormatter.init()
        formatter.dateFormat = "昨天 HH:mm"
        XCTAssertTrue(Date.getVariableFormatDateStringFromTimestamp(timestampString) == formatter.string(from: currentDate))
        print("=================" + Date.getLocalPopularTimeFromTimestamp(timestampString)!)
        XCTAssertTrue(Date.getLocalPopularTimeFromTimestamp(timestampString) == "1天前")
        
        timeInterval = timeInterval - 30 * 60 * 60 * 24
        timestampString = String.init(format: "%.f", timeInterval)
        currentDate = Date.init(timeIntervalSince1970: timeInterval)
        formatter = DateFormatter.init()
        formatter.dateFormat = "M月dd日 HH:mm"
        XCTAssertTrue(Date.getVariableFormatDateStringFromTimestamp(timestampString) == formatter.string(from: currentDate))
        XCTAssertTrue(Date.getLocalPopularTimeFromTimestamp(timestampString) == "1月前")
        
        timeInterval = timeInterval - 12 * 30 * 60 * 60 * 24
        timestampString = String.init(format: "%.f", timeInterval)
        currentDate = Date.init(timeIntervalSince1970: timeInterval)
        formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy年M月dd日"
        XCTAssertTrue(Date.getVariableFormatDateStringFromTimestamp(timestampString) == formatter.string(from: currentDate))
        XCTAssertTrue(Date.getLocalPopularTimeFromTimestamp(timestampString) == "1年前")
    }
    
    func test_general() throws {
        var date = self.currentDate
        XCTAssertTrue(date.year() == 2021,"年");
        XCTAssertTrue(date.month() == 3,"月");
        XCTAssertTrue(date.day() == 8,"日");
        XCTAssertTrue(date.hour() == 13,"小时");
        XCTAssertTrue(date.minute() == 54,"分");
        XCTAssertTrue(date.second() == 48,"秒");
        XCTAssertTrue(date.weekday() == 2,"星期单位");
        XCTAssertTrue(date.weekdayOrdinal() == 2,"第几个星期");
        XCTAssertTrue(date.weekOfMonth() == 2,"一个月中第几个星期");
        XCTAssertTrue(date.weekOfYear() == 11,"一年中第几个星期");
        XCTAssertTrue(date.quarter() == 0,"一小时中第几个刻钟");
        
        date = date.dateByAddingYears(years: 5)
        XCTAssertTrue(date.year() == 2026,"年");
        date = date.dateByAddingMonths(months: 5)
        XCTAssertTrue(date.month() == 8,"月");
        date = date.dateByAddingDays(days: 10)
        XCTAssertTrue(date.day() == 18,"日");
        date = date.dateByAddingHours(hours: 3)
        XCTAssertTrue(date.hour() == 16,"小时");
        date = date.dateByAddingMinutes(minutes: 2)
        XCTAssertTrue(date.minute() == 56,"分");
        date = date.dateByAddingSeconds(seconds: 2)
        XCTAssertTrue(date.second() == 50,"秒");
        date = date.dateByAddingWeeks(weeks: 0)
        XCTAssertTrue(date.weekdayOrdinal() == 3,"第几个星期");
        XCTAssertTrue(date.weekOfMonth() == 4,"一个月中第几个星期");
        XCTAssertTrue(date.quarter() == 0,"一小时中第几个刻钟");
        
        print("本地时间戳：\(Date.getLocalTimestamp())")
        XCTAssertTrue(Date.getTimeDifferenceString() == "GMT+8")
        XCTAssertTrue(Date.getTimeDifferenceWithUTCTime() == 8)
        print("计算相对现在的时间差：\(Date.getTimeIntervalWithCurrent(date: self.currentDate))")
        XCTAssertTrue(Date.calculatedTimeDifferenceWith(startTime: self.currentTimeInterval, endTime: self.ascendingTimeInterval) == 1)
        XCTAssertTrue(Date.calculatedTimeDifferenceWith(startTime: self.currentTimeInterval, endTime: self.descendingTimeInterval) == 1)
    }
    
    func test_vertification() throws {
        let date = Date.init()
        let newDate = date.dateByAddingDays(days: -1)
        XCTAssertTrue(date.isToday(), "日期是否为今天")
        XCTAssertFalse(newDate.isToday(), "日期不是今天")
        XCTAssertFalse(date.isYesterday(), "日期不是昨天")
        XCTAssertTrue(newDate.isYesterday(), "日期是昨天")
        
        XCTAssertTrue(Date.isSameDay(oneDate: date, anotherDate: date.dateByAddingHours(hours: -3)), "日期为同一天")
        XCTAssertFalse(Date.isSameDay(oneDate: date, anotherDate: newDate), "日期不为同一天")
        
        let result = Date.compareTwoTimes("2021-03-08 13:54:48", "2021-03-07 14:05:11", format: "yyyy-HH-dd HH:mm:ss")
        XCTAssertTrue(result.comparisionResult == ComparisonResult.orderedDescending)
        print((result.resultArray?.first)! + "-----" + (result.resultArray?.last)!)
        
        let result1 = Date.compareTwoTimes("2020-5-8", "2020-05-09", format: "yyyy-HH-dd")
        XCTAssertTrue(result1.comparisionResult == ComparisonResult.orderedAscending)
        print((result1.resultArray?.first)! + "-----" + (result1.resultArray?.last)!)
        
        let result2 = Date.compareTwoTimes("2020-5-8", "2020-05-08", format: "yyyy-HH-dd")
        XCTAssertTrue(result2.comparisionResult == ComparisonResult.orderedSame)
        print((result2.resultArray?.first)! + "-----" + (result2.resultArray?.last)!)
        
        let result3 = Date.compareTwoTimes("1615182888000", "1615097111000", format: "")
        XCTAssertTrue(result3.comparisionResult == ComparisonResult.orderedDescending)
        print((result3.resultArray?.first)! + "-----" + (result3.resultArray?.last)!)
        
        let result4 = Date.compareTwoTimes("1615182888000", "1615182888000", format: "")
        XCTAssertTrue(result4.comparisionResult == ComparisonResult.orderedSame)
        print((result4.resultArray?.first)! + "-----" + (result4.resultArray?.last)!)
        
        let result5 = Date.compareTwoTimes("1615182888000", "1615282888000", format: "")
        XCTAssertTrue(result5.comparisionResult == ComparisonResult.orderedAscending)
        print((result5.resultArray?.first)! + "-----" + (result5.resultArray?.last)!)
    }

}
