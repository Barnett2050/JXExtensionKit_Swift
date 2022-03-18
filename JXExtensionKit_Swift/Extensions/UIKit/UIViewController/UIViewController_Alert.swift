//
//  UIViewController_Alert.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/17.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

typealias AlertClickIndexBlock = (Int) ->Void // 按钮点击block
typealias AlertCancleBlock = () ->Void // 取消block

extension UIViewController {
    
    /// Alert系统提示
    /// - Parameters:
    ///   - title: 标题，NSAttributedString及其子类或者String,NSString均可
    ///   - message: 内容，NSAttributedString及其子类或者String,NSString均可
    ///   - btnTitleArr: 按钮标题数组
    ///   - btnColorArr: 按钮颜色数组，传入1个颜色默认全部按钮为该颜色
    ///   - clickBlock: 点击回调
    func showAlertController(title : AnyObject?, message : AnyObject?, btnTitleArr : Array<String>,btnColorArr : Array<UIColor>?,clickBlock : AlertClickIndexBlock?) {
        
        if (title == nil && message == nil) ||
            (btnTitleArr.isEmpty) {
            return
        }
        
        let alertTitle = title as? String
        let alertMessage = message as? String
        
        DispatchQueue.main.async {
            let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
            
            if title!.isKind(of: NSAttributedString.classForCoder()) {
                alertVC.setValue(title, forKey: "attributedTitle")
            } else if alertTitle?.count != 0 {
                alertVC.title = alertTitle
            }
            
            if message!.isKind(of: NSAttributedString.classForCoder()) {
                alertVC.setValue(message, forKey: "attributedMessage")
            } else if alertMessage?.count != 0 {
                alertVC.message = alertMessage
            }
            
            var colors : Array<UIColor>?

            if btnColorArr == nil || btnColorArr!.isEmpty || btnColorArr?.count != btnTitleArr.count {
                if btnColorArr?.count == 1 {
                    colors = btnColorArr
                } else {
                    colors = nil
                }
            } else {
                colors = btnColorArr
            }

            for (i,actionTitle) in btnTitleArr.enumerated() {
                let action = UIAlertAction.init(title: actionTitle, style: UIAlertAction.Style.default) { (alertAction) in
                    if clickBlock != nil {
                        let index = btnTitleArr.firstIndex(of: actionTitle)
                        if index != nil {
                            clickBlock!(index!)
                        }
                    }
                }
                if colors != nil && colors!.count != 0 {
                    if colors!.count == 1 {
                        action.setValue(colors!.first, forKey: "_titleTextColor")
                    } else {
                        action.setValue(colors![i], forKey: "_titleTextColor")
                    }
                }
                alertVC.addAction(action)
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    /// Alert系统提示,string
    func showAlertControllerString(title : String?, message : String?, btnTitleArr : Array<String>,btnColorArr : Array<UIColor>?,clickBlock : AlertClickIndexBlock?) {

        self.showAlertController(title: title as AnyObject?, message: message as AnyObject?, btnTitleArr: btnTitleArr, btnColorArr: btnColorArr, clickBlock: clickBlock)
    }
    /// Alert系统提示，无colors
    func showAlertControllerString(title : String?, message : String?, btnTitleArr : Array<String>,clickBlock : AlertClickIndexBlock?) {
        self.showAlertControllerString(title: title, message: message, btnTitleArr: btnTitleArr, btnColorArr: nil, clickBlock: clickBlock)
    }
    /// Alert系统提示，无button，无colors，默认取消确定按钮
    func showAlertControllerString(title : String?, message : String?, clickBlock : AlertClickIndexBlock?) {
        self.showAlertControllerString(title: title, message: message, btnTitleArr: ["取消","确定"], btnColorArr: nil, clickBlock: clickBlock)
    }
    
    
    /// AlertSheet系统提示，默认带取消按钮
    /// - Parameters:
    ///   - title: 标题，NSAttributedString及其子类或者String,NSString均可
    ///   - message: 内容，NSAttributedString及其子类或者String,NSString均可
    ///   - btnTitleArr: 按钮标题数组
    ///   - btnColorArr: 按钮颜色数组，传入1个颜色默认全部按钮为该颜色
    ///   - clickBlock: 点击回调
    ///   - cancleBlock: 取消回调，不需要显示可传nil
    func showAlertSheet(title : AnyObject?, message : AnyObject?, btnTitleArr : Array<String>,btnColorArr : Array<UIColor>?,clickBlock:AlertClickIndexBlock?,cancleBlock:AlertCancleBlock?) {
        
        if btnTitleArr.isEmpty {
            return
        }
        
        let alertTitle = title as? String
        let alertMessage = message as? String
        
        DispatchQueue.main.async {
            let alertVC = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            if title!.isKind(of: NSAttributedString.classForCoder()) {
                alertVC.setValue(title, forKey: "attributedTitle")
            } else if alertTitle?.count != 0 {
                alertVC.title = alertTitle
            }
            
            if message!.isKind(of: NSAttributedString.classForCoder()) {
                alertVC.setValue(message, forKey: "attributedMessage")
            } else if alertMessage?.count != 0 {
                alertVC.message = alertMessage
            }
            
            if cancleBlock != nil {
                let cancleAction = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.default) { (action) in
                    cancleBlock!()
                }
                alertVC.addAction(cancleAction)
            }
            
            var colors : Array<UIColor>?

            if btnColorArr == nil || btnColorArr!.isEmpty || btnColorArr?.count != btnTitleArr.count {
                if btnColorArr?.count == 1 {
                    colors = btnColorArr
                } else {
                    colors = nil
                }
            } else {
                colors = btnColorArr
            }

            for (i,actionTitle) in btnTitleArr.enumerated() {
                let action = UIAlertAction.init(title: actionTitle, style: UIAlertAction.Style.default) { (alertAction) in
                    if clickBlock != nil {
                        let index = btnTitleArr.firstIndex(of: actionTitle)
                        if index != nil {
                            clickBlock!(index!)
                        }
                    }
                }
                if colors != nil && colors!.count != 0 {
                    if colors!.count == 1 {
                        action.setValue(colors!.first, forKey: "_titleTextColor")
                    } else {
                        action.setValue(colors![i], forKey: "_titleTextColor")
                    }
                }
                alertVC.addAction(action)
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    /// AlertSheet系统提示，string
    func showAlertSheetString(title : String?, message : String?, btnTitleArr : Array<String>,btnColorArr : Array<UIColor>?,clickBlock:AlertClickIndexBlock?,cancleBlock:AlertCancleBlock?) {
        self.showAlertSheet(title: title as AnyObject?, message: message as AnyObject?, btnTitleArr: btnTitleArr, btnColorArr: btnColorArr, clickBlock: clickBlock, cancleBlock: cancleBlock)
    }
    /// AlertSheet系统提示，无message，默认带取消按钮
    func showAlertSheetString(title : String?, btnTitleArr : Array<String>,btnColorArr : Array<UIColor>?,clickBlock:AlertClickIndexBlock?,cancleBlock:AlertCancleBlock?) {
        self.showAlertSheetString(title: title, message: nil, btnTitleArr: btnTitleArr, btnColorArr: btnColorArr, clickBlock: clickBlock, cancleBlock: cancleBlock)
    }
    /// AlertSheet系统提示，无message，无colors，默认带取消按钮
    func showAlertSheetString(title : String?, btnTitleArr : Array<String>,clickBlock:AlertClickIndexBlock?,cancleBlock:AlertCancleBlock?) {
        self.showAlertSheetString(title: title, message: nil, btnTitleArr: btnTitleArr, btnColorArr: nil, clickBlock: clickBlock, cancleBlock: cancleBlock)
    }
    /// AlertSheet系统提示，无title，无message，默认带取消按钮
    func showAlertSheet(btnTitleArr : Array<String>,btnColorArr : Array<UIColor>?,clickBlock:AlertClickIndexBlock?,cancleBlock:AlertCancleBlock?) {
        self.showAlertSheet(title: nil, message: nil, btnTitleArr: btnTitleArr, btnColorArr: btnColorArr, clickBlock: clickBlock, cancleBlock: cancleBlock)
    }
    /// AlertSheet系统提示，无title，无message，无colors，默认带取消按钮
    func showAlertSheet(btnTitleArr : Array<String>,clickBlock:AlertClickIndexBlock?,cancleBlock:AlertCancleBlock?) {
        self.showAlertSheet(title: nil, message: nil, btnTitleArr: btnTitleArr, btnColorArr: nil, clickBlock: clickBlock, cancleBlock: cancleBlock)
    }
    
}
