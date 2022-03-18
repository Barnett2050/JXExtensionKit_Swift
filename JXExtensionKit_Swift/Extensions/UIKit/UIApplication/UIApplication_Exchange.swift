//
//  UIApplication_Exchange.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/23.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

// 定义方法交换协议
protocol MethodExchangeProtocol: AnyObject {
    static func awake()
    static func ExchangedForClass(_ forClass: AnyClass, originalSelector: Selector, exchangedSelector: Selector)
}

extension MethodExchangeProtocol {
    
    static func ExchangedForClass(_ forClass: AnyClass, originalSelector: Selector, exchangedSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let exchangeMethod = class_getInstanceMethod(forClass, exchangedSelector)
        guard (originalMethod != nil && exchangeMethod != nil) else {
            return
        }
        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(exchangeMethod!), method_getTypeEncoding(exchangeMethod!))
        // //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(forClass, exchangedSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, exchangeMethod!)
        }
    }
}
// 预加载类方法
class Preloading {
    // 获取到所有的类，遍历类，遵守协议JXSwizzlingProtocol的类执行awake方法
    static func ClassPreloadingFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? MethodExchangeProtocol.Type)?.awake()
        }
        types.deallocate()
    }
}

