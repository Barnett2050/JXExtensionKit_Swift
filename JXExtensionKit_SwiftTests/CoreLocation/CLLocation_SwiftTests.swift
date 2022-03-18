//
//  CLLocation_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/3/10.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest
import CoreLocation

//@testable import CLLocation_Converter

class CLLocation_SwiftTests: XCTestCase {
    
    let wgs84Location = CLLocationCoordinate2DMake(39.91488908, 116.40387397)
    let gcj02Location = CLLocationCoordinate2DMake(39.91629336, 116.41011847)
    let bd09Location = CLLocationCoordinate2DMake(39.92238898, 116.41658019)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Converter() throws {
        let wgs84ToGcj02 = wgs84Location.wgs84ToGcj02()
        XCTAssertTrue((fabs(wgs84ToGcj02.latitude - self.gcj02Location.latitude) < 0.00001 &&
                       fabs(wgs84ToGcj02.longitude - self.gcj02Location.longitude) < 0.00001),"地球坐标转换火星坐标");
        
        let gcj02ToWgs84 = gcj02Location.gcj02ToWgs84()
        XCTAssertTrue((fabs(gcj02ToWgs84.latitude - self.wgs84Location.latitude) < 0.00001 &&
                       fabs(gcj02ToWgs84.longitude - self.wgs84Location.longitude) < 0.00001),"火星坐标转换地球坐标");
        
        let wgs84ToBd09 = wgs84Location.wgs84ToBd09()
        XCTAssertTrue((fabs(wgs84ToBd09.latitude - self.bd09Location.latitude) < 0.00001 &&
                       fabs(wgs84ToBd09.longitude - self.bd09Location.longitude) < 0.00001),"地球坐标转换百度坐标");
        
        let gcj02ToBd09 = gcj02Location.gcj02ToBd09()
        XCTAssertTrue((fabs(gcj02ToBd09.latitude - self.bd09Location.latitude) < 0.00001 &&
                       fabs(gcj02ToBd09.longitude - self.bd09Location.longitude) < 0.00001),"火星坐标转换百度坐标");
        
        let bd09ToGcj02 = bd09Location.bd09ToGcj02()
        XCTAssertTrue((fabs(bd09ToGcj02.latitude - self.gcj02Location.latitude) < 0.00001 &&
                       fabs(bd09ToGcj02.longitude - self.gcj02Location.longitude) < 0.00001),"百度坐标转换火星坐标");
        
        let bd09ToWgs84 = bd09Location.bd09ToWgs84()
        XCTAssertTrue((fabs(bd09ToWgs84.latitude - self.wgs84Location.latitude) < 0.00001 &&
                       fabs(bd09ToWgs84.longitude - self.wgs84Location.longitude) < 0.00001),"百度坐标转换地球坐标");
    }
    
    func test_JXCalculation() throws {
        let location1 = CLLocationCoordinate2DMake(40.89804, 106.9962)
        let location2 = CLLocationCoordinate2DMake(40.30524, 107.0077)
        XCTAssertTrue(location1.getKmDistanceWith(locationCoordinate: location2) == location1.getKmDistanceWith(locationLat: location2.latitude, locationLon: location2.longitude))
        print(location1.getKmDistanceWith(locationCoordinate: location2))
        
        let expectation = XCTestExpectation.init(description: "IS IN CHINA")
        location1.locationIsOutOfChina { (result) in
            print("=====%ld",result)
            expectation.fulfill()
        }
        
        let expectation2 = XCTestExpectation.init(description: "description")
        location1.placeDescriptionFromLocation { (error, country, locality, subLocality, thoroughfare, name) in
            print("%@-%@-%@-%@-%@",country ?? "",locality ?? "",subLocality ?? "",thoroughfare ?? "",name ?? "");
            expectation2.fulfill()
        }
        
        let expectation3 = XCTestExpectation.init(description: "placemarks")
        let name = "唐山"
        name.placemarksWithLocation { (error, placemarks) in
            if placemarks?.count ?? 0 != 0 {
                for placemark in placemarks! {
                    print("Longitude = \(placemark.location!.coordinate.longitude)")
                    print("Latitude = \(placemark.location!.coordinate.latitude)")
                }
                expectation3.fulfill()
            }
        }
        
        self.wait(for: [expectation,expectation2,expectation3], timeout: 3)
    }

}
