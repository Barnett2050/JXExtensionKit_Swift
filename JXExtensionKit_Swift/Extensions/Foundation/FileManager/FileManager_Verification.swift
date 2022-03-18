//
//  FileManager_Verification.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/14.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// 判断文件是否存在
    /// - Parameter path: 文件路径
    /// - Returns: true:文件存在. false:不存在.
    class func fileIsExists(_ path : String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// 创建目录(已判断是否存在，无脑用就行)
    /// - Parameter path: 路径
    class func createDirectoryFile(_ path : String) -> Bool {
        var isDir : ObjCBool = false
        let fileManager = FileManager.default
        let existed = fileManager.fileExists(atPath: path, isDirectory: &isDir)
        var result = false
        
        //目标路径的目录不存在则创建目录
        if isDir.boolValue && existed {
            result = true
        } else if !existed && isDir.boolValue {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                result = true
            } catch {
                result = false
                debugPrint(error.localizedDescription)
            }
        } else {
            result = false
        }
        return result
    }
    
    /// 计算指定路径下的文件是否超过了规定时间
    /// - Parameters:
    ///   - path: 文件路径
    ///   - timeout: 设定的超时时间,单位秒
    class func isTimeoutWithPath(_ path : String,timeout : TimeInterval) -> Bool {
        guard let info = try? FileManager.default.attributesOfItem(atPath: path) else {
            return false
        }
        let creationDate = info[FileAttributeKey.creationDate] as! Date
        let currentDate = NSDate.init()
        return currentDate.timeIntervalSince(creationDate) > timeout
    }
    
    /// 重置文件夹
    /// - Parameter finderPath: 文件路径
    /// - Returns: true:重置成功. false:重置失败.
    class func resetFinderWithPath(_ finderPath : String) -> Bool {
        var result = false
        if FileManager.default.fileExists(atPath: finderPath) {
            do {
                try FileManager.default.removeItem(atPath: finderPath)
            } catch  {
                debugPrint(error.localizedDescription)
            }
        }
        do {
            try FileManager.default.createDirectory(atPath: finderPath, withIntermediateDirectories: true, attributes: nil)
            result = true
        } catch  {
            result = false
            debugPrint(error.localizedDescription)
        }
        return result
    }
    
    /// 删除文件
    /// - Parameter path: 文件路径
    /// - Returns: true:删除成功. false:删除失败
    class func removeFileWithPath(_ path : String) -> Bool {
        if FileManager.default.fileExists(atPath: path) == false {
            return true
        }
        var result = false
        do {
            try FileManager.default.removeItem(atPath: path)
            result = true
        } catch  {
            result = false
            debugPrint(error.localizedDescription)
        }
        return result
    }
    
    /// 路径是否是文件类型，true 文件类型 false 文件夹类型
    /// - Parameter filePath: 文件路径
    class func isDirectory(_ filePath : String) -> Bool {
        var isDirectory : ObjCBool = false
        FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    /// 移动文件
    /// - Parameters:
    ///   - srcPath: 源路径
    ///   - dstPath: 目标路径
    class func moveItemAtPath(_ srcPath : String,dstPath : String) -> Bool {
        let srcExisted = FileManager.default.fileExists(atPath: srcPath)
        if srcExisted == false {
            return false
        }
        let flag = self.createDirectoryFile(dstPath)
        if flag == false {
            return false
        }
        var moveStatus = false
        do {
            try FileManager.default.moveItem(atPath: srcPath, toPath: dstPath)
            moveStatus = true
        } catch {
            moveStatus = false
            debugPrint(error.localizedDescription)
        }
        return moveStatus
    }
}
