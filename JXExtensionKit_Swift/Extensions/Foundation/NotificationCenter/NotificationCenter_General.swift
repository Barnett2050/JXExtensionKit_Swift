//
//  NSNotificationCenter_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/4.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension NotificationCenter {
    
    /// 在主线程上将通知发送给接收者。
    /// - Parameters:
    ///   - notification: 定义通知
    ///   - wait: 指定是否阻塞当前线程直到指定选择器在主线程中执行完毕。选择YES会阻塞这个线程；选择NO，本方法会立刻返回。
    class func postNotificationOnMainThread(notification : Notification,wait : Bool) {
        if pthread_main_np() != 0 {
            return self.default.post(notification)
        }
        NotificationCenter.perform(#selector(NotificationCenter.p_postNotification(notification:)), on: Thread.main, with: notification, waitUntilDone: wait)
    }
    
    /// 在主线程上向接收者发送给定的通知。如果当前线程是主线程，则通知被同步发送；否则，被异步发送。
    /// - Parameter notification: 定义通知
    class func postNotificationOnMainThread(notification : Notification) {
        if pthread_main_np() != 0 {
            return self.default.post(notification)
        }
        self.postNotificationOnMainThread(notification: notification, wait: false)
    }
    
    /// 创建具有给定名称和发送方的通知，并将其发布到主线程上的接收方。 如果当前线程是主线程，则通知被同步发布； 否则，将被异步发布。
    class func postNotificationOnMainThreadWithName(name : String,object : Any?,userInfo : Dictionary<AnyHashable, Any>?,wait : Bool) {
        if pthread_main_np() != 0 {
            return self.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
        }
        var info : Dictionary<AnyHashable, Any>? = Dictionary.init()
        info!["name"] = name
        info!["object"] = object
        info!["userInfo"] = userInfo
        
        NotificationCenter.perform(#selector(NotificationCenter.p_postNotificationName(info:)), on: Thread.main, with: info, waitUntilDone: wait)
    }
    
    /// 创建具有给定名称和发送方的通知，并将其发布到主线程上的接收方。 如果当前线程是主线程，则通知被同步发布； 否则，将被异步发布。
    class func postNotificationOnMainThreadWithName(name : String,object : Any?,userInfo : Dictionary<AnyHashable, Any>?) {
        if pthread_main_np() != 0 {
            return self.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
        }
        self.postNotificationOnMainThreadWithName(name: name, object: object, userInfo: userInfo, wait: false)
    }
    
    /// 创建具有给定名称和发送方的通知，并将其发布到主线程上的接收方。 如果当前线程是主线程，则通知被同步发布； 否则，将被异步发布。
    class func postNotificationOnMainThreadWithName(name : String,object : Any?) {
        if pthread_main_np() != 0 {
            return self.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: nil)
        }
        self.postNotificationOnMainThreadWithName(name: name, object: object, userInfo: nil, wait: false)
    }
    
    //    MARK: private
    @objc private class func p_postNotification(notification : Notification) {
        self.default.post(notification)
    }
    
    @objc private class func p_postNotificationName(info : Dictionary<AnyHashable,Any>?) {
        let name : String = info?["name"] as! String
        let object = info?["object"]
        let userInfo = info?["userInfo"] as? [AnyHashable : Any]
        
        self.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
    }
}
