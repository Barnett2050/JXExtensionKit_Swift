//
//  UIApplication_Notification.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/2.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    /// 通知是否启用
    /// - Parameter authorityBlock: 回调block
    class func userNotificationIsEnable(authorityBlock : ((Bool) -> Void)?) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.notDetermined {
                DispatchQueue.main.async {
                    if authorityBlock != nil {
                        authorityBlock!(false)
                    }
                }
            } else if settings.authorizationStatus == UNAuthorizationStatus.denied {
                DispatchQueue.main.async {
                    if authorityBlock != nil {
                        authorityBlock!(false)
                    }
                }
            } else if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                DispatchQueue.main.async {
                    if authorityBlock != nil {
                        authorityBlock!(true)
                    }
                }
            }
        }
    }
    
    /// 跳转App系统通知设置
    class func goToAppSystemSetting() {
        let application = UIApplication.shared
        let url = URL.init(string: UIApplication.openSettingsURLString)!
        if application.canOpenURL(url) {
            application.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /// 注册通知
    /// - Parameter centerDelegate: 协议对象
    class func registerRemoteNotificationWith(centerDelegate : Any) {
#if targetEnvironment(simulator)// 模拟器
        debugPrint("模拟器不进行通知注册")
#else
        DispatchQueue.main.async {
            let center = UNUserNotificationCenter.current()
            center.delegate = (centerDelegate as! UNUserNotificationCenterDelegate)
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (registered, error) in
                if registered {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
#endif
    }
}
