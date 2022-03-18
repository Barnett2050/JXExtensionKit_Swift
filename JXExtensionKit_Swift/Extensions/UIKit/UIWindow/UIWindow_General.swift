//
//  UIWindow_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/15.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    /// 获取主窗体
    /// - Returns: UIWindow
    class func getCurrentWindow() -> UIWindow? {
        let array = UIApplication.shared.windows
        var tmpWin : UIWindow?
        for value in array.reversed() {
            if value.windowLevel == UIWindow.Level.normal && value.rootViewController != nil {
                tmpWin = value
                break
            }
        }
        return tmpWin
    }
    /// /// 导航栈的栈顶视图控制器
    /// - Returns: 控制器
    class func topViewController() -> UIViewController? {
        let window = UIWindow.getCurrentWindow()
        if window == nil {
            return nil
        }
        var result : UIViewController?
        var nextResponder : AnyObject?
        var frontView : UIView?
        for subView in window!.subviews {
            if subView.isKind(of: NSClassFromString("UITransitionView")!) {
                frontView = subView.subviews.last
            }
            nextResponder = frontView?.next
            if nextResponder == nil {
                continue
            } else
            {
                if nextResponder!.isKind(of: UIViewController.classForCoder()) {
                    result = nextResponder as? UIViewController
                    result = UIWindow.topViewController(result: result!)
                    break
                } else {
                    frontView = nil
                    continue
                }
            }
        }
        if frontView == nil {
            result = window?.rootViewController
            result = UIWindow.topViewController(result: result!)
        }
        return result
    }
    
    /// 获取当前显示的控制器
    /// - Returns: 控制器
    class func visibleViewController() -> UIViewController? {
        let window = UIApplication.shared.delegate!.window ?? nil;
        if window == nil {
            return nil
        } else {
            let rootViewController = window!.rootViewController
            return UIWindow.getVisibleViewControllerFrom(value: rootViewController)
        }
    }
    
    // MARK: 私有方法
    private class func topViewController(result : UIViewController) -> UIViewController {
        var topVC : UIViewController!
        if result.isKind(of: UINavigationController.classForCoder()) {
            topVC = result.value(forKeyPath: "topViewController") as? UIViewController
        } else if result.isKind(of: UITabBarController.classForCoder()) {
            topVC = result.value(forKeyPath: "selectedViewController") as? UIViewController
        } else {
            return result
        }
        return UIWindow.topViewController(result: topVC)
    }
    private class func getVisibleViewControllerFrom(value : UIViewController?) -> UIViewController? {
        if value == nil {
            return nil
        }
        if value!.isKind(of: UINavigationController.classForCoder()) {
            return UIWindow.getVisibleViewControllerFrom(value: (value as! UINavigationController).visibleViewController!)
        } else if value!.isKind(of: UITabBarController.classForCoder()) {
            return UIWindow.getVisibleViewControllerFrom(value: (value as! UITabBarController).selectedViewController!)
        } else {
            if value!.presentedViewController != nil {
                return UIWindow.getVisibleViewControllerFrom(value: value!.presentedViewController!)
            } else {
                return value
            }
        }
    }
}
