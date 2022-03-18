//
//  Data_Compress.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2021/4/19.
//  Copyright © 2021 Barnett. All rights reserved.
//

import Foundation
import zlib

/**解压缩流大小**/
private let GZIP_STREAM_SIZE: Int32 = Int32(MemoryLayout<z_stream>.size)
/**解压缩缓冲区大小**/
private let GZIP_BUF_LENGTH:Int = 512
/**默认空数据**/
private let GZIP_NULL_DATA = Data()

extension Data {
    /// 如果数据经过gzip编码，则此方法将返回YES。
    func isGzippedData() -> Bool {
        return self.starts(with: [0x1f,0x8b])
    }
    
    /// 如果数据经过zlib编码，则此方法将返回YES。
    func isZlibbedData() -> Bool {
        return self.starts(with: [0x78,0x9c])
    }
    
    /// 此方法将应用gzip deflate算法并返回压缩数据。 压缩级别是介于0.0和1.0之间的浮点值，其中0.0表示无压缩，而1.0表示最大压缩。 值0.1将提供最快的压缩率。 如果提供负值，这将应用默认的压缩级别，该值大约等于0.7。
    /// - Parameter level: 0.0 ~ 1.0
    mutating func gzippedDataWithCompressionLevel(_ level : Float) -> Data? {
        if self.isEmpty || self.isGzippedData() { return self }
       
        var stream = z_stream()
        stream.avail_in = uInt(self.count)
        stream.next_in = self.withUnsafeMutableBytes({ (rawBufferPointer) -> UnsafeMutablePointer<Bytef>? in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: Bytef.self)
            let unsafePointer = unsafeBufferPointer.baseAddress!
            return UnsafeMutablePointer.init(mutating: unsafePointer)
        })
        stream.total_out = 0
        stream.avail_out = 0

        let compression : Int = Int(level < 0.0 ? Z_DEFAULT_COMPRESSION : (Int32(level) * 9))
        
        var status = deflateInit2_(&stream,Int32(compression), Z_DEFLATED, MAX_WBITS + 16, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY, ZLIB_VERSION, GZIP_STREAM_SIZE)
        
        if status != Z_OK {
            return GZIP_NULL_DATA
        }
        
        var compressedData = Data()
        while stream.avail_out == 0 {
            
            if Int(stream.total_out) >= compressedData.count {
                compressedData.count += GZIP_BUF_LENGTH
            }
            
            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            stream.next_out = compressedData.withUnsafeMutableBytes({ (unsafeMutableRawBufferPointer) -> UnsafeMutablePointer<Bytef> in
                let unsafeBufferPointer : UnsafeMutableBufferPointer<Bytef> = unsafeMutableRawBufferPointer.bindMemory(to: Bytef.self)
                let unsafePointer : UnsafeMutablePointer<Bytef> = unsafeBufferPointer.baseAddress!
                return unsafePointer.advanced(by: Int(stream.total_out))
            })
            status = deflate(&stream, Z_FINISH)
            
            if status != Z_OK && status != Z_STREAM_END {
                return GZIP_NULL_DATA
            }
        }
        
        guard deflateEnd(&stream) == Z_OK else {
            return GZIP_NULL_DATA
        }
        
        compressedData.count = Int(stream.total_out)
        return compressedData
    }
    
    /// 默认压缩级别。
    mutating func gzippedData() -> Data? {
        return self.gzippedDataWithCompressionLevel(-1)
    }
    
    /// 此方法将解压缩使用deflate算法压缩的数据并返回结果。
    mutating func gunzippedData() -> Data? {
        guard self.count > 0  else {
            return GZIP_NULL_DATA
        }
        guard self.isGzippedData() else {
            return self
        }
        var stream = z_stream()
        stream.avail_in = uInt(self.count)
        stream.total_out = 0
        stream.next_in = self.withUnsafeMutableBytes({ (rawBufferPointer) -> UnsafeMutablePointer<Bytef>? in
            let unsafeBufferPointer = rawBufferPointer.bindMemory(to: Bytef.self)
            let unsafePointer = unsafeBufferPointer.baseAddress!
            return UnsafeMutablePointer.init(mutating: unsafePointer)
        })
        
        var status: Int32 = inflateInit2_(&stream, MAX_WBITS + 16, ZLIB_VERSION,GZIP_STREAM_SIZE)
        guard status == Z_OK else {
            return GZIP_NULL_DATA
        }
        
        var decompressed = Data(capacity: self.count * 2)
        while stream.avail_out == 0 {

            stream.avail_out = uInt(GZIP_BUF_LENGTH)
            decompressed.count += GZIP_BUF_LENGTH

            stream.next_out = decompressed.withUnsafeMutableBytes({ (unsafeMutableRawBufferPointer) -> UnsafeMutablePointer<Bytef> in
                let unsafeBufferPointer : UnsafeMutableBufferPointer<Bytef> = unsafeMutableRawBufferPointer.bindMemory(to: Bytef.self)
                let unsafePointer : UnsafeMutablePointer<Bytef> = unsafeBufferPointer.baseAddress!
                return unsafePointer.advanced(by: Int(stream.total_out))
            })
            
            status = inflate(&stream, Z_SYNC_FLUSH)

            if status != Z_OK && status != Z_STREAM_END {
                break
            }
        }
        
        if inflateEnd(&stream) != Z_OK {
            return GZIP_NULL_DATA
        }
        
        decompressed.count = Int(stream.total_out)
        return decompressed
    }
}
