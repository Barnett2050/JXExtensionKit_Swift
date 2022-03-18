//
//  UINavigationController_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/2.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    /// 设置导航栏背景颜色和阴影颜色
    /// - Parameters:
    ///   - barColor: 背景颜色
    ///   - shadowColor: 阴影颜色
    func setNavigationBarColor(_ barColor : UIColor,shadowColor : UIColor) {
        let barImg = UIImage.squareImageWith(tintColor: barColor, targetSize: CGSize.init(width: UIScreen.main.bounds.size.width, height: 88))
        let shadowImg = UIImage.squareImageWith(tintColor: shadowColor, targetSize: CGSize.init(width: UIScreen.main.bounds.size.width, height: 1))
        
        self.navigationBar.setBackgroundImage(barImg, for: UIBarMetrics.default)
        self.navigationBar.shadowImage = shadowImg
    }
}
