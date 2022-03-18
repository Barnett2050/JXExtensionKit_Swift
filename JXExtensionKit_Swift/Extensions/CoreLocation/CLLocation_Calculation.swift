//
//  CLLocation_Calculation.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/15.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension CLLocationCoordinate2D {

    /// 计算两个坐标间的距离，单位 米
    /// - Parameter locationCoordinate: 另一个坐标
    func getKmDistanceWith(locationCoordinate : CLLocationCoordinate2D) -> Double {
        return LocationCalculationTool.getKmDistance(oneLocation: self, anotherLocation: locationCoordinate)
    }
    
    /// 计算两个坐标间的距离，单位 米
    /// - Parameters:
    ///   - locationLat: 另一个坐标 纬度
    ///   - locationLon: 另一个坐标 经度
    func getKmDistanceWith(locationLat:Double,locationLon:Double) -> Double {
        return LocationCalculationTool.getKmDistance(latOne: self.latitude, lonOne: self.longitude, latAnother: locationLat, lonAnother: locationLon)
    }
    
    /// 判断坐标是否已经超出中国范围
    func locationIsOutOfChina(callBack :@escaping (_ inChina :Bool)->Void) -> Void {
        LocationCalculationTool.locationIsOutOfChina(self) { (result) in
            callBack(result)
        }
    }
    
    /// 根据坐标获取位置描述（逆地理编码）
    /// - Parameters:
    ///   - location: 坐标
    ///   - callBack: 回调 国家-country 城市-locality 区-subLocality 街道-thoroughfare 具体位置-name
    func placeDescriptionFromLocation(callBack :@escaping (_ error : Error?,_ country : String?,_ locality : String?,_ subLocality : String?,_ thoroughfare : String?,_ name : String?) -> Void) -> Void {
        LocationCalculationTool.placeDescriptionFromLocation(location: CLLocation.init(latitude: self.latitude, longitude: self.longitude), callBack: callBack)
    }
}

extension CLLocation {
    
    /// 计算两个坐标间的距离，单位 米
    func getKmDistanceWith(location : CLLocation) -> Double {
        return LocationCalculationTool.getKmDistance(oneLocation: self.coordinate, anotherLocation: location.coordinate)
    }
    /// 判断坐标是否已经超出中国范围
    func locationIsOutOfChina(callBack :@escaping (_ inChina :Bool)->Void) -> Void {
        LocationCalculationTool.locationIsOutOfChina(self.coordinate) { (result) in
            callBack(result)
        }
    }
    /// 根据坐标获取位置描述（逆地理编码）
    /// - Parameters:
    ///   - location: 坐标
    ///   - callBack: 回调 国家-country 城市-locality 区-subLocality 街道-thoroughfare 具体位置-name
    func placeDescriptionFromLocation(callBack :@escaping (_ error : Error?,_ country : String?,_ locality : String?,_ subLocality : String?,_ thoroughfare : String?,_ name : String?) -> Void) -> Void {
        LocationCalculationTool.placeDescriptionFromLocation(location: self, callBack: callBack)
    }
}

extension String {
    /// 根据地址获取坐标（地理编码）
    func placemarksWithLocation(callBack :@escaping (_ error : Error?,_ placemarks: Array<CLPlacemark>?) -> Void) -> Void {
        LocationCalculationTool.placemarksWithLocation(locationDescription: self, callBack: callBack)
    }
}

private class LocationCalculationTool {
    /// 计算两个坐标间的距离，单位 米
    /// - Parameter oneLocation: 第一个坐标
    /// - Parameter anotherLocation: 另一个坐标
    class func getKmDistance(oneLocation:CLLocationCoordinate2D,anotherLocation:CLLocationCoordinate2D) -> Double {
        let orig = CLLocation.init(latitude: oneLocation.latitude, longitude: oneLocation.longitude)
        let dist = CLLocation.init(latitude: anotherLocation.latitude, longitude: anotherLocation.longitude)
        let kilometers = orig .distance(from: dist)
        return kilometers
    }
    
    /// 计算两个坐标间的距离，单位 米
    class func getKmDistance(latOne:Double,lonOne:Double,latAnother:Double,lonAnother:Double) -> Double {
        let orig = CLLocation.init(latitude: latOne, longitude: lonOne)
        let dist = CLLocation.init(latitude: latAnother, longitude: lonAnother)
        let kilometers = orig .distance(from: dist)
        return kilometers
    }
    
    /// 判断是否已经超出中国范围
    /// - Parameters:
    ///   - locationCoordinate: 坐标
    ///   - callBack: 回调
    class func locationIsOutOfChina(_ locationCoordinate : CLLocationCoordinate2D,callBack : @escaping (_ inChina :Bool)->Void) -> Void {
        let newLocation = CLLocation.init(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        CLGeocoder.init().reverseGeocodeLocation(newLocation) { (placemarks, error) in
            if error != nil || placemarks == nil || placemarks!.isEmpty {
                debugPrint("不能确定是在中国")
            } else {
                let placemark = placemarks!.first
                if placemark!.isoCountryCode == "CN" {
                    callBack(true)
                } else {
                    callBack(false)
                }
                
            }
        }
    }
    
    /// 根据坐标获取位置描述（逆地理编码）
    /// - Parameters:
    ///   - location: 坐标
    ///   - callBack: 回调 国家-country 城市-locality 区-subLocality 街道-thoroughfare 具体位置-name
    class func placeDescriptionFromLocation(location : CLLocation,callBack :@escaping (_ error : Error?,_ country : String?,_ locality : String?,_ subLocality : String?,_ thoroughfare : String?,_ name : String?) -> Void) -> Void {
        let clGeoCoder = CLGeocoder.init()
        clGeoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil && placemarks?.count ?? 0 > 0 {
                let placeMark = placemarks?.first;
                callBack(nil,placeMark?.country,placeMark?.locality,placeMark?.subLocality,placeMark?.thoroughfare,placeMark!.name)
            }else if error == nil && (placemarks == nil || placemarks!.isEmpty) {
                callBack(nil,"","","","","");
            }else if error != nil {
                callBack(error,"","","","","");
            }
        }
    }
    
    /// 根据地址获取坐标（地理编码）
    /// - Parameters:
    ///   - locationDescription: 地址描述
    ///   - callBack: 回调
    class func placemarksWithLocation(locationDescription : String,callBack :@escaping (_ error : Error?,_ placemarks: Array<CLPlacemark>?) -> Void) -> Void {
        let geoCoder = CLGeocoder.init()
        geoCoder.geocodeAddressString(locationDescription) { (placemarks, error) in
            if placemarks?.count ?? 0 > 0 && error == nil {
                callBack(nil,placemarks);
            }else if error == nil && (placemarks == nil || placemarks!.isEmpty) {
                callBack(nil,nil);
            }else if error != nil {
                callBack(error,nil);
            }
        }
    }
}
