//
//  Timer_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/9.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension Timer {
    
    /// 暂停Timer
    func pauseTimer() {
        if self.isValid == false {
            return
        }
        self.fireDate = Date.distantFuture
    }
    
    /// 恢复Timer
    func resumeTimer() {
        if self.isValid == false {
            return
        }
        self.fireDate = Date.init()
    }
    
    /// 过一段时间继续Timer
    /// - Parameter interval: 时间间隔
    func resumeTimerAfterTimeInterval(_ interval : TimeInterval) {
        if self.isValid == false {
            return
        }
        self.fireDate = Date.init(timeIntervalSinceNow: interval)
    }
}
