//
//  NSObject_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// 判断方法是否在子类里override了
    /// - Parameters:
    ///   - cls: 传入要判断的Class
    ///   - sel: 传入要判断的Selector
    /// - Returns: 返回判断是否被重载的结果
    class func methodIsOverride(cls:AnyClass,sel:Selector) -> Bool {
        let clsIMP = class_getMethodImplementation(cls, sel)
        let superClsIMP = class_getMethodImplementation(cls.superclass(), sel)
        
        return clsIMP != superClsIMP
    }
    
    /// 输出系统类方法
    class func printClassMethodList() {
        var methodCount : UInt32 = 0
        let methodList = class_copyMethodList(self.classForCoder(), &methodCount)
        if methodCount == 0 {
            debugPrint("无系统类方法")
            return
        }
        for i in 0 ..< methodCount {
            let temp = methodList![Int(i)]
            let name_s = sel_getName(method_getName(temp))
            let arguments = method_getNumberOfArguments(temp)
            let encoding = method_getTypeEncoding(temp)
            
            debugPrint(String.init(format: "方法名：%@,参数个数：%d,编码方式：%@",String.init(utf8String: name_s) ?? "",arguments,String.init(utf8String: encoding!) ?? ""))
        }
    }
    
    /// 输出系统类属性
    class func printClassPropertyList() {
        var count : UInt32 = 0
        let propertys = class_copyPropertyList(self.classForCoder(), &count)
        if count == 0 {
            debugPrint("无系统类属性")
            return
        }
        var mutableSet = Set<String>.init()
        
        for i in 0 ..< count {
            let property = propertys![Int(i)]
            let name = property_getName(property)
            mutableSet.insert(String.init(format: "%s",name))
        }
        debugPrint("nameCount:\(mutableSet.count)")
        for item in mutableSet {
            debugPrint("name: \(item)")
        }
    }
    
    /// 输出自定义类属性
    class func printCustomClassPropertyList(){
        let dic = self.init().properties_mapDictionary()
        if dic == nil || dic!.isEmpty {
            debugPrint("custom property：null")
            return
        }
        for item in Array(dic!.keys) {
            debugPrint("custom property：" + item)
        }
    }
    
    /// 返回自定义类属性字典
    func properties_mapDictionary() -> Dictionary<String, Any>? {
        let mirror = Mirror(reflecting: self)
        return self.mapDic(mirror: mirror)
    }
    
    //    MARK:private
    private func mapDic(mirror: Mirror) -> [String: Any] {
        var dic: [String: Any] = [:]
        for child in mirror.children {
            // 如果没有labe就会被抛弃
            if let label = child.label {
                dic[label] = child.value
            }
        }
        // 添加父类属性
        if let superMirror = mirror.superclassMirror {
            let superDic = mapDic(mirror: superMirror)
            for p in superDic {
                dic[p.key] = p.value
            }
        }
        return dic
    }
}
