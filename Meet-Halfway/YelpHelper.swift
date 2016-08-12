//
//  YelpHelper.swift
//  Meet-Halfway
//
//  Created by Laya Indukuri on 8/9/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import YelpAPI
import CoreLocation

class YelpHelper {
    
    static var category = ""
    static var sortType = ""
    
    static func yelpAccess(completionBlock: ([YLPBusiness]) -> Void) {
        let client = YLPClient(consumerKey: "Fzh1WjfT5Q5qIsxmgJix1w", consumerSecret: "xcyrKWM7y6pi3Sft5jlEujFQRno", token: "TeSzJiV_ToBRIe4weD9m_8UTCR8yY9na", tokenSecret: "4lu-KdxO2GXfjzE38mrryduz6ik")
        
        let midpointCoordinates = MidpointHelper.assignMidpoint()
        
        client.searchWithGeoCoordinate(YLPGeoCoordinate(latitude: midpointCoordinates.latitude, longitude: midpointCoordinates.longitude, accuracy: 0, altitude: 0, altitudeAccuracy: 0), currentLatLong: MidpointHelper.assignMidpoint().yelpCoordinate, term: category, limit: 5, offset: 0, sort: .Distance) { (search: YLPSearch?,error: NSError?) -> Void in
            
            
            completionBlock(search!.businesses)
        }
    
    }

}

extension CLLocationCoordinate2D {
    
    var yelpCoordinate: YLPCoordinate {
        return YLPCoordinate(latitude: self.latitude, longitude: self.longitude)
    }
    
}

//
//
//@property (nonatomic, nullable, readonly) YLPRegion *region;
//@property (nonatomic, readonly) NSArray<YLPBusiness *> *businesses;
//@property (nonatomic, readonly) NSUInteger total;
//

//        client.searchWithGeoCoordinate(YLPGeoCoordinate(latitude: midpointCoordinates.latitude, longitude: midpointCoordinates.longitude, accuracy: 0, altitude: 0, altitudeAccuracy: 0))  { (search: YLPSearch?,error: NSError?) -> Void in
//
//            let restaurants = search!.businesses.filter { $0.categories.map { $0.alias }.contains("restaurants") }
//
//            completionBlock(Array(restaurants[0..<5]))
//
//        }
