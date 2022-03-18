//
//  NotificationCenter_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/3/11.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest
import UIKit

class NotificationCenter_SwiftTests: XCTestCase {
    
    let notificationNameTest1 = "notificationNameTest1"
    
    override func setUpWithError() throws {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationSelector1(noti:)), name: NSNotification.Name(rawValue: notificationNameTest1), object: nil)
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let expectation = XCTestExpectation.init(description: "notification")
        DispatchQueue.global().async {
            let noti = Notification.init(name: Notification.Name(rawValue: self.notificationNameTest1))
            
            NotificationCenter.postNotificationOnMainThread(notification: noti)
            NotificationCenter.postNotificationOnMainThread(notification: noti, wait: true)
            NotificationCenter.postNotificationOnMainThreadWithName(name: self.notificationNameTest1, object: nil)
            NotificationCenter.postNotificationOnMainThreadWithName(name: self.notificationNameTest1, object: nil, userInfo: nil)
            NotificationCenter.postNotificationOnMainThreadWithName(name: self.notificationNameTest1, object: nil, userInfo: nil, wait: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    func notificationSelector1(noti : NSNotification) -> Void {
        print("\(Thread.current)------\(Thread.current.isMainThread)----------\(noti.userInfo)")
    }
}
