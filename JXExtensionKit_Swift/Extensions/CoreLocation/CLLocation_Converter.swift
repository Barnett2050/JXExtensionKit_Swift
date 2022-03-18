//
//  CLLocation_Converter.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/15.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension CLLocationCoordinate2D {
    
    /// 世界标准地理坐世标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
    func wgs84ToGcj02() -> CLLocationCoordinate2D {
        return LocationConverterTool.gcj02Encrypt(lat: self.latitude, lon: self.longitude)
    }
    /// 中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84），此接口有1－2米左右的误差，需要精确定位情景慎用
    func gcj02ToWgs84() -> CLLocationCoordinate2D {
        return LocationConverterTool.gcj02Decrypt(lat: self.latitude, lon: self.longitude)
    }
    /// 世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
    func wgs84ToBd09() -> CLLocationCoordinate2D {
        let gcj02Pt = LocationConverterTool.gcj02Encrypt(lat: self.latitude, lon: self.longitude)
        return LocationConverterTool.bd09Encrypt(lat: gcj02Pt.latitude, lon: gcj02Pt.longitude)
    }
    /// 中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
    func gcj02ToBd09() -> CLLocationCoordinate2D {
        return LocationConverterTool.bd09Encrypt(lat: self.latitude, lon: self.longitude)
    }
    /// 百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
    func bd09ToGcj02() -> CLLocationCoordinate2D {
        return LocationConverterTool.bd09Decrypt(lat: self.latitude, lon: self.longitude)
    }
    /// 百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）此接口有1－2米左右的误差，需要精确定位情景慎用
    func bd09ToWgs84() -> CLLocationCoordinate2D {
        let gcj02 = LocationConverterTool.bd09Decrypt(lat: self.latitude, lon: self.longitude)
        return LocationConverterTool.gcj02Decrypt(lat: gcj02.latitude, lon: gcj02.longitude)
    }
}

private class LocationConverterTool {
    
    class func gcj02Encrypt(lat:Double,lon:Double) -> CLLocationCoordinate2D {
        var resPoint = CLLocationCoordinate2D.init()
        var mgLat:Double = 0.0
        var mgLon:Double = 0.0
        if LocationConverterTool.OutOfChina(lat: lat, lon: lon) {
            resPoint.latitude = lat;
            resPoint.longitude = lon;
            return resPoint
        }
        var dLat = LocationConverterTool.transformLat(x: lon-105.0, y: lat-35.0)
        var dLon = LocationConverterTool.transformLon(x: lon-105.0, y: lat-35.0)
        let radLat = lat / 180.0 * Double.pi
        var magic = sin(radLat)
        magic = 1 - LocationConverterTool.jzEE * magic * magic;
        let sqrtMagic = sqrt(magic)
        dLat = (dLat * 180.0) / ((LocationConverterTool.jzA * (1 - LocationConverterTool.jzEE)) / (magic * sqrtMagic) * Double.pi);
        dLon = (dLon * 180.0) / (LocationConverterTool.jzA / sqrtMagic * cos(radLat) * Double.pi);
        mgLat = lat + dLat;
        mgLon = lon + dLon;
        
        resPoint.latitude = mgLat;
        resPoint.longitude = mgLon;
        
        return resPoint
    }
    class func gcj02Decrypt(lat:Double,lon:Double) -> CLLocationCoordinate2D {
        let gPt = LocationConverterTool.gcj02Encrypt(lat: lat, lon: lon)
        let dLon = gPt.longitude - lon;
        let dLat = gPt.latitude - lat;
        var pt : CLLocationCoordinate2D = CLLocationCoordinate2D.init();
        pt.latitude = lat - dLat;
        pt.longitude = lon - dLon;
        return pt;
    }
    class func bd09Decrypt(lat:Double,lon:Double) -> CLLocationCoordinate2D {
        var gcjPt:CLLocationCoordinate2D = CLLocationCoordinate2D.init();
        let x = lon - 0.0065, y = lat - 0.006;
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * Double.pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * Double.pi)
        gcjPt.longitude = z * cos(theta)
        gcjPt.latitude = z * sin(theta)
        return gcjPt
    }
    class func bd09Encrypt(lat:Double,lon:Double) -> CLLocationCoordinate2D {
        var bdPt:CLLocationCoordinate2D = CLLocationCoordinate2D.init();
        let x = lon, y = lat;
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * Double.pi)
        let theta = atan2(y, x) + 0.000003 * cos(x * Double.pi)
        bdPt.longitude = z * cos(theta) + 0.0065
        bdPt.latitude = z * sin(theta) + 0.006
        return bdPt
    }
    
    // MARK:私有方法
    private class func LAT_OFFSET_0(x:Double,y:Double) -> Double {
        let result = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
        return result
    }
    private class func LAT_OFFSET_1(x:Double,y:Double) -> Double {
        let result = (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0
        return result
    }
    private class func LAT_OFFSET_2(x:Double,y:Double) -> Double {
        let result = (20.0 * sin(y * Double.pi) + 40.0 * sin(y / 3.0 * Double.pi)) * 2.0 / 3.0
        return result
    }
    private class func LAT_OFFSET_3(x:Double,y:Double) -> Double {
        let result = (160.0 * sin(y / 12.0 * Double.pi) + 320 * sin(y * Double.pi / 30.0)) * 2.0 / 3.0
        return result
    }
    private class func LON_OFFSET_0(x:Double,y:Double) -> Double {
        let result = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x))
        return result
    }
    private class func LON_OFFSET_1(x:Double,y:Double) -> Double {
        let result = (20.0 * sin(6.0 * x * Double.pi) + 20.0 * sin(2.0 * x * Double.pi)) * 2.0 / 3.0
        return result
    }
    private class func LON_OFFSET_2(x:Double,y:Double) -> Double {
        let result = (20.0 * sin(x * Double.pi) + 40.0 * sin(x / 3.0 * Double.pi)) * 2.0 / 3.0
        return result
    }
    private class func LON_OFFSET_3(x:Double,y:Double) -> Double {
        let result = (150.0 * sin(x / 12.0 * Double.pi) + 300.0 * sin(x / 30.0 * Double.pi)) * 2.0 / 3.0
        return result
    }
    static let RANGE_LON_MAX = 137.8347
    static let RANGE_LON_MIN = 72.004
    static let RANGE_LAT_MAX = 55.8271
    static let RANGE_LAT_MIN = 0.8293
    static let jzA = 6378245.0
    static let jzEE = 0.00669342162296594323
    
    private class func transformLat(x:Double,y:Double) -> Double {
        var ret = LAT_OFFSET_0(x: x, y: y)
        ret += LAT_OFFSET_1(x: x, y: y)
        ret += LAT_OFFSET_2(x: x, y: y)
        ret += LAT_OFFSET_3(x: x, y: y)
        return ret
    }
    
    private class func transformLon(x:Double,y:Double) -> Double {
        var ret = LON_OFFSET_0(x: x, y: y)
        ret += LON_OFFSET_1(x: x, y: y)
        ret += LON_OFFSET_2(x: x, y: y)
        ret += LON_OFFSET_3(x: x, y: y)
        return ret
    }
    
    private class func OutOfChina(lat:Double,lon:Double) -> Bool {
        if lon < LocationConverterTool.RANGE_LON_MIN || lon > LocationConverterTool.RANGE_LON_MAX {
            return true
        }
        if lat < LocationConverterTool.RANGE_LAT_MIN || lat > LocationConverterTool.RANGE_LAT_MAX{
            return true
        }
        return false
    }
}
