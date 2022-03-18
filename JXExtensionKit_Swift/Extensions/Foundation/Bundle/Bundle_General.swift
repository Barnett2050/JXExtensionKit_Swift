//
//  Bundle_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/26.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// 获取app应用名称
    class func getApplicationName() -> String? {
        let app_Name = self.main.infoDictionary?["CFBundleName"] as? String ?? ""
        return app_Name
    }
    
    /// 获取 APP 应用版本, 1.0.0
    class func getApplicationVersion() -> String? {
        let app_Version = self.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return app_Version
    }
    
    /// 获取BundleID,com.xxx.xxx
    class func getBundleID() -> String? {
        let app_Identifier = self.main.bundleIdentifier
        return app_Identifier
    }
    
    /// 获取编译版本,123
    class func getBuildVersion() -> String? {
        let app_Build = self.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        return app_Build
    }
    
    /// 当前应用版本是否需要更新
    class func currentAppVersionIsUpdateWith(newVersion : String?) -> Bool {
        let currentVersion = Bundle.getApplicationVersion() ?? ""
        if currentVersion.isEmpty || newVersion == nil || newVersion!.isEmpty{
            return false
        }
        let flag = newVersion!.compare(currentVersion, options: .numeric, range: newVersion!.startIndex ..< newVersion!.endIndex, locale: Locale.current) == ComparisonResult.orderedDescending
        return flag
    }
    
    /// 获取mainBundle中内容
    /// - Parameters:
    ///   - name: 名称 xxx
    ///   - type: 后缀 jpg/png
    class func mainBundleData(name : String?,type : String?) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: type)
        if path == nil { return nil }
        guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path!)) else {
            return nil
        }
        return data
    }
}
