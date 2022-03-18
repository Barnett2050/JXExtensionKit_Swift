//
//  UIDevice_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/8/25.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit
import AdSupport
import MachO

struct ApplicationMemoryCurrentUsage{
    var total : Double = 0.0
    var usage : Double = 0.0
    var free  : Double = 0.0
    var ratio : Double = 0.0
}

extension UIDevice {
    
    // MARK: 设备信息
    /// 获取 通用 - 关于本机 - 名称
    class func getDeviceUserName() -> String {
        return UIDevice.current.name
    }

    /// 获取设备类型 - iPhone/iTouch/iPad
    class func getDeviceModel() -> String {
        return UIDevice.current.model
    }
    
    /// 获取系统名称 - iOS
    class func getDeviceSystemName() -> String {
        return UIDevice.current.systemName
    }
    
    /// 获取设备系统版本 - 13.3/12.0
    class func getDeviceSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 获取设备电量 0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
    class func getDeviceBattery() -> Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        return batteryLevel
    }
    
    /// 获取手机本地语言 zh-Hans-CN/en
    class func getCurrentLocalLanguage() -> String {
        let languages = NSLocale.preferredLanguages
        let currentLanguage = languages[0]
        return currentLanguage
    }
    
    /// 获取设备名称，例：iPhone 11 Pro Max
    class func getDeviceName() -> String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let phoneTypeDictionary = ["iPhone1,1":"iPhone 2G",
                                   "iPhone1,2":"iPhone 3G",
                                   "iPhone2,1":"iPhone 3GS",
                                   "iPhone3,1":"iPhone 4",
                                   "iPhone3,2":"iPhone 4",
                                   "iPhone3,3":"iPhone 4",
                                   "iPhone4,1":"iPhone 4S",
                                   "iPhone5,1":"iPhone 5",
                                   "iPhone5,2":"iPhone 5",
                                   "iPhone5,3":"iPhone 5c",
                                   "iPhone5,4":"iPhone 5c",
                                   "iPhone6,1":"iPhone 5s",
                                   "iPhone6,2":"iPhone 5s",
                                   "iPhone7,1":"iPhone 6 Plus",
                                   "iPhone7,2":"iPhone 6",
                                   "iPhone8,1":"iPhone 6s",
                                   "iPhone8,2":"iPhone 6s",
                                   "iPhone8,4":"iPhone SE (1st generation)",
                                   "iPhone9,1":"iPhone 7",
                                   "iPhone9,2":"iPhone 7 Plus",
                                   "iPhone9,3":"iPhone 7",
                                   "iPhone9,4":"iPhone 7 Plus",
                                   "iPhone10,1":"iPhone 8",
                                   "iPhone10,4":"iPhone 8",
                                   "iPhone10,2":"iPhone 8 Plus",
                                   "iPhone10,5":"iPhone 8 Plus",
                                   "iPhone10,3":"iPhone X",
                                   "iPhone10,6":"iPhone X",
                                   "iPhone11,8":"iPhone XR",
                                   "iPhone11,2":"iPhone XS",
                                   "iPhone11,6":"iPhone XS Max",
                                   "iPhone11,4":"iPhone XS Max",
                                   "iPhone12,1":"iPhone 11",
                                   "iPhone12,3":"iPhone 11 Pro",
                                   "iPhone12,5":"iPhone 11 Pro Max",
                                   "iPhone12,8":"iPhone SE (2nd generation)",
                                   "iPhone13,1":"iPhone 12 mini",
                                   "iPhone13,2":"iPhone 12",
                                   "iPhone13,3":"iPhone 12 Pro",
                                   "iPhone13,4":"iPhone 12 Pro Max",]
        if identifier.contains("iPhone") {
            return phoneTypeDictionary[identifier]
        }
        
        let podTypeDictionary = ["iPod1,1":"iPod Touch 1G",
                                 "iPod2,1":"iPod Touch 2G",
                                 "iPod3,1":"iPod Touch 3G",
                                 "iPod4,1":"iPod Touch 4G",
                                 "iPod5,1":"iPod Touch 5G",
                                 "iPod7,1":"iPod Touch 6G",
                                 "iPod9,1":"iPod Touch 7G"]
        if identifier.contains("iPod") {
            return podTypeDictionary[identifier]
        }
        
        let padTypeDictionary = ["iPad1,1":"iPad 1",
                                 "iPad2,1":"iPad 2",
                                 "iPad2,2":"iPad 2",
                                 "iPad2,3":"iPad 2",
                                 "iPad2,4":"iPad 2",
                                 "iPad2,5":"iPad mini 1",
                                 "iPad2,6":"iPad mini 1",
                                 "iPad2,7":"iPad mini 1",
                                 "iPad3,1":"iPad 3",
                                 "iPad3,2":"iPad 3",
                                 "iPad3,3":"iPad 3",
                                 "iPad3,4":"iPad 4",
                                 "iPad3,5":"iPad 4",
                                 "iPad3,6":"iPad 4",
                                 "iPad4,1":"iPad Air",
                                 "iPad4,2":"iPad Air",
                                 "iPad4,3":"iPad Air",
                                 "iPad4,4":"iPad mini 2",
                                 "iPad4,5":"iPad mini 2",
                                 "iPad4,6":"iPad mini 2",
                                 "iPad4,7":"iPad mini 3",
                                 "iPad4,8":"iPad mini 3",
                                 "iPad4,9":"iPad mini 3",
                                 "iPad5,1":"iPad mini 4",
                                 "iPad5,2":"iPad mini 4",
                                 "iPad5,3":"iPad Air 2",
                                 "iPad5,4":"iPad Air 2",
                                 "iPad6,3":"iPad Pro 9.7",
                                 "iPad6,4":"iPad Pro 9.7",
                                 "iPad6,7":"iPad Pro 12.9",
                                 "iPad6,8":"iPad Pro 12.9",
                                 "iPad6,11":"iPad 5",
                                 "iPad6,12":"iPad 5",
                                 "iPad7,1":"iPad Pro 2 12.9",
                                 "iPad7,2":"iPad Pro 2 12.9",
                                 "iPad7,3":"iPad Pro 10.5",
                                 "iPad7,4":"iPad Pro 10.5",
                                 "iPad7,5":"iPad 6",
                                 "iPad7,6":"iPad 6",
                                 "iPad7,11":"iPad 7",
                                 "iPad7,12":"iPad 7",
                                 "iPad8,1":"iPad Pro 11.0",
                                 "iPad8,2":"iPad Pro 11.0",
                                 "iPad8,3":"iPad Pro 11.0",
                                 "iPad8,4":"iPad Pro 11.0",
                                 "iPad8,5":"iPad Pro 3 12.9",
                                 "iPad8,6":"iPad Pro 3 12.9",
                                 "iPad8,7":"iPad Pro 3 12.9",
                                 "iPad8,8":"iPad Pro 3 12.9",
                                 "iPad8,9":"iPad Pro 2 11.0",
                                 "iPad8,10":"iPad Pro 2 11.0",
                                 "iPad8,11":"iPad Pro 4 12.9",
                                 "iPad8,12":"iPad Pro 4 12.9",
                                 "iPad11,1":"iPad mini 5",
                                 "iPad11,2":"iPad mini 5",
                                 "iPad11,3":"iPad Air 3",
                                 "iPad11,4":"iPad Air 3",
                                 "iPad11,6":"iPad 8",
                                 "iPad11,7":"iPad 8",
                                 "iPad13,1":"iPad Air 4",
                                 "iPad13,2":"iPad Air 4"]
        if identifier.contains("iPad") {
            return padTypeDictionary[identifier]
        }
        
        if identifier.contains("i386") || identifier.contains("x86_64") {
            return "iPhone Simulator"
        }
        return identifier
    }
    
    // MARK: 设备标识
    /// 获取IDFA
    class func getIDFA() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    /// 获取IDFV
    class func getIDFV() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    /// 获取UUID
    class func getUUID() -> String {
        return NSUUID.init().uuidString
    }
    
    // MARK: 磁盘空间
    /// 获取当前设备磁盘总容量(单位：MB）
    class func getDiskSpaceTotal() -> Double {
        guard let attrs: [FileAttributeKey : Any] = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return -1
        }
        var space = (attrs[.systemSize] as? NSNumber)?.int64Value ?? 0
        if space < 0 {
            space = -1
        }
        return Double(space/1000/1000)
    }
    
    /// 获取当前设备磁盘剩余容量(单位：MB）
    class func getDiskSpaceFree() -> Double {
        guard let attrs: [FileAttributeKey : Any] = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return -1
        }
        var space = (attrs[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
        if space < 0 {
            space = -1
        }
        return Double(space/1000/1000)
    }
    
    /// 获取当前设备磁盘使用容量(单位：MB）
    class func getDiskSpaceUsed() -> Double {
        let total = self.getDiskSpaceTotal()
        let free = self.getDiskSpaceFree()
        if total < 0 || free < 0 {
            return -1
        }
        var used = total - free
        if used < 0 {
            used = -1
        }
        return used
    }
    
    // MARK: 内存信息
    func getUsedMemory()->ApplicationMemoryCurrentUsage {
        var applicationUseageMemory = ApplicationMemoryCurrentUsage.init()
        var usedMemory: Int64 = 0
        let hostPort: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        var pagesize:vm_size_t = 0
        host_page_size(hostPort, &pagesize)
        var vmStat: vm_statistics = vm_statistics_data_t()
        let vmStatSize = MemoryLayout.size(ofValue: vmStat)
        let strideSize = MemoryLayout<Int32>.stride
        let status: kern_return_t = withUnsafeMutableBytes(of: &vmStat) {
            let boundPtr = $0.baseAddress?.bindMemory(to: Int32.self, capacity:vmStatSize / strideSize)
            return host_statistics(hostPort, HOST_VM_INFO, boundPtr, &host_size)
        }
        if status == KERN_SUCCESS {
 
            usedMemory = (Int64)((vm_size_t)(vmStat.active_count + vmStat.inactive_count + vmStat.wire_count) * pagesize)
            let total = (Int64)(ProcessInfo.processInfo.physicalMemory)
            applicationUseageMemory.total = Double(total)
            applicationUseageMemory.usage = Double(usedMemory)
            applicationUseageMemory.free = Double(total - usedMemory)
            applicationUseageMemory.ratio = (Double)(usedMemory) / (Double)(total)
            return applicationUseageMemory
        }else {
            print("Failed to get Virtual memory inforor")
            return applicationUseageMemory
        }
    }        
    // MARK: CPU信息
    /// cpu数量
    func getCPUCount() -> UInt {
        return UInt(ProcessInfo.processInfo.activeProcessorCount)
    }
}
