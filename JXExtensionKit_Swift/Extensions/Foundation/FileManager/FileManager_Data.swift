//
//  NSFileManager_Data.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/14.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// 获取单个文件的大小
    /// - Parameter filePath: 文件路径
    class func fileSizeAtPath(_ filePath : String) -> Double {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            guard let dic = try? manager.attributesOfItem(atPath: filePath) else {
                return 0
            }
            let theSize = dic[FileAttributeKey.size] as! Double
            return theSize
        }
        return 0
    }
    
    /// 获取单个文件的大小
    /// - Parameter filePath: 文件路径
    /// - Returns: 文件大小 B,KB,MB,GB 保留两位
    class func fileSizeStringAtPath(_ filePath : String) -> String? {
        let fileSize = self.fileSizeAtPath(filePath)
        if fileSize == 0 {
            return nil
        } else {
            var ret = String.init()
            if fileSize <= 0 {
                ret = "0.00B"
            } else if fileSize < 1024 {
                ret = String.init(format: "%.2fB", fileSize)
            } else if fileSize < 1024 * 1024 {
                ret = String.init(format: "%.2fkB", fileSize/1024)
            } else if fileSize < 1024 * 1024 * 1024 {
                ret = String.init(format: "%.2fMB", fileSize/(1024 * 1024))
            } else {
                ret = String.init(format: "%.2fGB", fileSize/(1024 * 1024 * 1024))
            }
            return ret
        }
    }
    
    /// 向itunes共享文件夹中写入文件，即NSDocumentDirectory
    /// - Parameters:
    ///   - data: 数据
    ///   - directory: 文件夹名称
    ///   - fileName: 文件名称
    ///   - resultBlock: 回调
    class func writeDataToSharedDocumentsWith(data : Data,directory : String?,fileName : String?,resultBlock : ((Bool)->Void)?) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsPath = paths[0]
        var filePath : String? = nil
        if directory != nil {
            filePath = String.init(format: "%@/%@/", documentsPath,directory!)
            if FileManager.default.fileExists(atPath: filePath!) == false {
                do {
                    try FileManager.default.createDirectory(atPath: filePath!, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        } else {
            filePath = documentsPath
        }
        if fileName != nil {
            filePath = filePath! + fileName!
        }
        if resultBlock != nil {
            var flag : Bool = true
            do {
                try data.write(to: URL.init(fileURLWithPath: filePath!), options: Data.WritingOptions.atomic)
            } catch {
                flag = false;
                debugPrint(error.localizedDescription)
            }
            resultBlock!(flag)
        }
    }
    
    /// 向文件写入数据
    /// - Parameters:
    ///   - filePath: 文件路径
    ///   - data: 内容
    class func writeDataToFile(_ filePath : String,data : Data) {
        if FileManager.default.fileExists(atPath: filePath) {
            let flag = FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
            if flag == false {
                return
            }
        }
        DispatchQueue.global().async {
            let fileHandle = FileHandle.init(forUpdatingAtPath: filePath)
            fileHandle?.seekToEndOfFile() //将节点跳到文件的末尾
            fileHandle?.write(data) //追加写入数据
            fileHandle?.closeFile()
        }
    }
}
