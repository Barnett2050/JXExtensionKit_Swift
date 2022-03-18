//
//  UIViewController_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/17.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 设置系统标题颜色和字体
    /// - Parameters:
    ///   - color: 颜色
    ///   - font: 字体
    func setNavigationBarTitle(color: UIColor?,font: UIFont?) {
        if self.navigationController == nil {
            return
        }
        var dictionary: [NSAttributedString.Key: AnyObject] = [:]
        if color != nil {
            dictionary[.foregroundColor] = color
        }
        if font != nil {
            dictionary[.font] = font
        }
        self.navigationController?.navigationBar.titleTextAttributes = dictionary
    }
    
    /// 返回按钮点击事件
    /// - Parameters:
    ///   - sender: 按钮
    ///   - dismissCompletion: 完成回调
    func clickReturnBarButtonItemAction(sender: UIButton?,dismissCompletion: (()->Void)?) {
        if self.navigationController == nil {
            return
        }
        if self.navigationController!.viewControllers.count != 1 {
            self.navigationController!.popViewController(animated: true)
        } else {
            self.navigationController!.dismiss(animated: true, completion: dismissCompletion)
        }
    }
    
    /// 隐藏返回按钮
    func hiddenLeftBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: nil, style: .done, target: nil, action: nil)
    }
}
