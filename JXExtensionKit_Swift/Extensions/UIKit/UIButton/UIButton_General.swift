//
//  UIButton_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/2.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIButton : MethodExchangeProtocol {
    private struct AssociatedKey {
        static var eventTimeInterval: String = "eventTimeInterval"
        static var ignoreEventTimeInterval: String = "ignoreEventTimeInterval"
        static var hitEdgeInsets: String = "hitEdgeInsets"
    }
    /// bool true 忽略点击事件   false 允许点击事件
    private var ignoreEventTimeInterval : Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.ignoreEventTimeInterval, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.ignoreEventTimeInterval) as? Bool ?? false
        }
    }
    /// 为按钮添加点击间隔 单位：秒
    var eventTimeInterval : Double {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.eventTimeInterval, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.eventTimeInterval) as? Double ?? 0.0
        }
    }
    /// 扩展点击区域，默认为（0，0，0，0)负为扩大
    var hitEdgeInsets : UIEdgeInsets {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.hitEdgeInsets, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.hitEdgeInsets) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    
    public func overrideSendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        
    }
    
    static func awake() {
        buttonExchangeMethod
    }
    // 保证只会执行一次
    private static let buttonExchangeMethod: Void = {
        let originalSelector = #selector(sendAction(_:to:for:))
        let exchangeSelector = #selector(button_exchanged_sendAction(_:to:for:))
        ExchangedForClass(UIButton.self, originalSelector: originalSelector, exchangedSelector: exchangeSelector)
    }()
    
    @objc func button_exchanged_sendAction(_ action:Selector,to target:Any,for event:UIEvent) -> Void {
        if self.eventTimeInterval == 0  {
            button_exchanged_sendAction(action, to: target, for: event)
        }else
        {
            if self.ignoreEventTimeInterval == true {
                return
            }else
            {
                if self.eventTimeInterval <= 0.0 {
                    return
                }else
                {
                    DispatchQueue.main.asyncAfter(deadline: .now()+self.eventTimeInterval) {
                        self.ignoreEventTimeInterval = false
                    }
                }
            }
            self.ignoreEventTimeInterval = true
            // 给外部子类自定义方法
            self.overrideSendAction(action, to: target, for: event)
            // 这里看上去会陷入递归调用死循环，但在运行期此方法是和sendAction:to:forEvent:互换的，相当于执行sendAction:to:forEvent:方法，所以并不会陷入死循环。
            
            button_exchanged_sendAction(action, to: target, for: event)
        }
    }
        
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.hitEdgeInsets != UIEdgeInsets.zero {
            var btnBounds = self.bounds
            btnBounds = btnBounds.inset(by: self.hitEdgeInsets)
            return btnBounds.contains(point)
        } else {
            return self.bounds.contains(point)
        }
    }
    
    open override class func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
}
