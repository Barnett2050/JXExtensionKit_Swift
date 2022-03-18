//
//  FileManager_FilePath.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/14.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

public enum FileManagerPathType : UInt {
    case DocumentPathType // 读写
    case CachesPathType // 读写
    case PreferencesPathType // 读写
    case TempPathType // 读写
    case BundlePathType // 读
}

extension FileManager {
    
    /// 快速返回沙盒中，你指定的系统文件的路径。tmp文件除外，tmp用系统的NSTemporaryDirectory()函数更加便捷
    /// - Parameter directory: SearchPathDirectory枚举
    /// - Returns: 快速你指定的系统文件的路径
    class func pathForSystemFile(directory : FileManager.SearchPathDirectory) -> String? {
        return NSSearchPathForDirectoriesInDomains(directory, FileManager.SearchPathDomainMask.userDomainMask, true).last
    }
    
    /// 快速返回沙盒中，你指定的系统文件的中某个子文件的路径。tmp文件除外，请使用filePathAtTempWithFileName，不创建文件
    /// - Parameters:
    ///   - directory: SearchPathDirectory枚举
    ///   - fileName: 子文件名
    /// - Returns: 快速你指定的系统文件的路径
    class func filePathForSystemFile(directory : FileManager.SearchPathDirectory,fileName : String) -> String {
        return self.pathForSystemFile(directory: directory)!.appendingFormat("/%@", fileName)
    }
    
    /// 快速返回沙盒中选定文件夹的路径
    /// - Parameter pathType: FileManagerPathType
    class func directoryPathFor(pathType : FileManagerPathType) -> String? {
        var path : String? = nil
        
        switch pathType {
        case .DocumentPathType:
            path = self.pathForSystemFile(directory: .documentDirectory)
        case .CachesPathType:
            path = self.pathForSystemFile(directory: .cachesDirectory)
        case .PreferencesPathType:
            path = self.pathForSystemFile(directory: .preferencePanesDirectory)
        case .TempPathType:
            path = NSTemporaryDirectory()
        case .BundlePathType:
            path = Bundle.main.bundlePath
        }
        if path?.last == "/" {
            path?.removeLast()
        }
        return path
    }
    
    /// 快速返回沙盒中选定文件的路径
    /// - Parameters:
    ///   - pathType: 类型
    ///   - fileName: 文件名称
    ///   - isCreat: 没有文件是否创建
    class func filePathAt(pathType : FileManagerPathType,fileName : String,isCreat : Bool) -> String {
        let filePath = self.directoryPathFor(pathType: pathType)!.appendingFormat("/%@", fileName)
        if FileManager.default.fileExists(atPath: filePath) == false && isCreat {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        return filePath
    }
    
    /// 快速返回沙盒中选定文件夹的路径
    /// - Parameters:
    ///   - pathType: 类型
    ///   - directoryName: 文件夹名称
    ///   - isCreat: 没有文件是否创建
    class func directoryPathAt(pathType : FileManagerPathType,directoryName : String,isCreat : Bool) -> String {
        let directoryPath = self.directoryPathFor(pathType: pathType)!.appendingFormat("/%@", directoryName)
        if FileManager.default.fileExists(atPath: directoryPath) == false && isCreat {
            do {
                try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return directoryPath
    }
}
