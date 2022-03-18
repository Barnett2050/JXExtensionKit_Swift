//
//  NSObject_KVO.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
/* swift 的观察者模式
 因为Swift 4中继承 NSObject 的 swift class 不再默认全部 bridge 到 OC,然而 KVO 又是一个纯 OC 的特性，所以如果是 swift class 需要在声明的时候增加 @objcMembers 关键字。
 另外一件事就是被观察的属性需要用dynamic修饰，否则也无法观察到
 一个好消息是不需要在对象被回收时手动 remove observer。但是这也带来了另外一个容易被忽略的事情：观察的闭包没有被强引用，需要我们自己添加引用，否则当前函数离开后这个观察闭包就会被回收了。
 */
extension NSObject {
    
    private struct AssociatedKey {
        static var block_key: String = "block_key"
    }
    private var p_allNSObjectObserverBlocks : Dictionary<String, Any>? {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.block_key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let targets = objc_getAssociatedObject(self, &AssociatedKey.block_key) as? Dictionary<String, Any> ?? Dictionary.init()
            return targets
        }
    }
    
    /// 观察者中介
    private class NSObjectKVOBlockTarget: NSObject {
        
        var block : ((_ obj:Any?,_ oldVal:Any?,_ newVal:Any?) -> ())?
        
        init(block:@escaping (_ obj:Any?,_ oldVal:Any?,_ newVal:Any?)->()) {
            super.init()
            self.block = block
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            
            if self.block == nil || change == nil {
                return
            }
            let priorKey = change![NSKeyValueChangeKey.notificationIsPriorKey]
            if priorKey != nil && priorKey as! Bool {
                return
            }
    
            let oldVal = change![NSKeyValueChangeKey.oldKey]
            let newVal = change![NSKeyValueChangeKey.newKey]
            self.block!(object,oldVal,newVal)
        }
    }
    
    /// 添加一个kvo的block
    func addObserverBlockForKeyPath(_ keyPath : String?,block : @escaping (_ obj:Any?,_ oldVal:Any?,_ newVal:Any?)->()) {
        if keyPath == nil || keyPath!.isEmpty {
            return
        }
        let target = NSObjectKVOBlockTarget.init(block: block)
        var dic = self.p_allNSObjectObserverBlocks ?? Dictionary.init()
        var arr = dic[keyPath!] as? Array<Any>
        if arr == nil {
            arr = Array.init()
        }
        arr?.append(target)
        dic[keyPath!] = arr
        self.p_allNSObjectObserverBlocks = dic
        self.addObserver(target, forKeyPath: keyPath!, options: [.new,.old], context: nil)
    }
    
    /// 根据给定的keyPath移除相应的观察者
    func removeObserverBlocksForKeyPath(_ keyPath : String?) {
        if keyPath == nil {
            return
        }
        var dic = self.p_allNSObjectObserverBlocks ?? Dictionary.init()
        let arr = dic[keyPath!] as? Array<NSObject> ?? nil
        if arr == nil || arr!.isEmpty {
            return
        }
        for item in arr! {
            self.removeObserver(item, forKeyPath: keyPath!)
        }
        dic.removeValue(forKey: keyPath!)
        self.p_allNSObjectObserverBlocks = dic
    }
    
    /// 释放所有的观察者
    func removeAllObserverBlocks() {
        var dic = self.p_allNSObjectObserverBlocks ?? Dictionary.init()
        for (key, value) in dic {
            let arr = value as! Array<NSObject>
            for item in arr {
                self.removeObserver(item, forKeyPath: key)
            }
        }
        dic.removeAll()
        self.p_allNSObjectObserverBlocks = nil
    }
}
