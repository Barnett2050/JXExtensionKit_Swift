//
//  UITabBarController_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/2.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

let TABBAR_HEIGHT : CGFloat = 49

extension UITabBarController {
    
    /// 设置tabbar背景颜色和阴影颜色
    /// - Parameters:
    ///   - barColor: 背景颜色
    ///   - shadowColor: 阴影颜色
    func setTabBarColor(_ barColor : UIColor,shadowColor : UIColor) {
        let barImg = UIImage.squareImageWith(tintColor: barColor, targetSize: CGSize.init(width: UIScreen.main.bounds.size.width, height: 49))
        let shadowImg = UIImage.squareImageWith(tintColor: shadowColor, targetSize: CGSize.init(width: UIScreen.main.bounds.size.width, height: 1))
        
        let tabbar = UITabBar.appearance()
        tabbar.backgroundImage = barImg
        tabbar.shadowImage = shadowImg
    }
    
    /// 设置tabbar 文字normal颜色和selected颜色
    /// - Parameters:
    ///   - normalColor: 正常颜色
    ///   - selectedColor: 选中颜色
    func setTabbarTitleNormalColor(_ normalColor : UIColor,selectedColor : UIColor) {
        // 普通状态下的文字属性
        var normalAttrs = Dictionary<NSAttributedString.Key, Any>.init()
        normalAttrs[NSAttributedString.Key.foregroundColor] = normalColor
        // 选中状态下的文字属性
        var selectedAttrs = Dictionary<NSAttributedString.Key, Any>.init()
        selectedAttrs[NSAttributedString.Key.foregroundColor] = selectedColor
        
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(normalAttrs, for: .normal)
        tabBarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
    }
    
    /// tabbar动态显示和隐藏
    /// - Parameters:
    ///   - hidden: 是否隐藏
    ///   - animated: 动画
    func setTabBarHidden(_ hidden : Bool,animated : Bool) {
        if self.view.subviews.count < 2 {
            return
        }
        if hidden {
            if animated {
                UIView.animate(withDuration: 0.2, animations: {
                    self.tabBar.frame = CGRect.init(x: self.view.bounds.origin.x,
                                                    y: self.view.bounds.size.height,
                                                    width: self.view.bounds.size.width,
                                                    height: TABBAR_HEIGHT)
                }) { (finished : Bool) in
                    self.tabBar.frame = CGRect.init(x: self.view.bounds.origin.x,
                                                    y: self.view.bounds.size.height,
                                                    width: self.view.bounds.size.width,
                                                    height: TABBAR_HEIGHT)
                }
            } else {
                self.tabBar.frame = CGRect.init(x: self.view.bounds.origin.x,
                                                y: self.view.bounds.size.height,
                                                width: self.view.bounds.size.width,
                                                height: TABBAR_HEIGHT)
            }
        } else {
            if animated {
                UIView.animate(withDuration: 0.2, animations: {
                    self.tabBar.frame = CGRect.init(x: self.view.bounds.origin.x,
                                                    y: self.view.bounds.size.height - TABBAR_HEIGHT,
                                                    width: self.view.bounds.size.width,
                                                    height: TABBAR_HEIGHT)
                }) { (finished : Bool) in
                    
                }
            } else {
                self.tabBar.frame = CGRect.init(x: self.view.bounds.origin.x,
                                                y: self.view.bounds.size.height - TABBAR_HEIGHT,
                                                width: self.view.bounds.size.width,
                                                height: TABBAR_HEIGHT)
            }
        }
    }
}
