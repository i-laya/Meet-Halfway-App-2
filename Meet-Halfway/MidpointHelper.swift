//
//  MidpointHelper.swift
//  Meet-Halfway
//
//  Created by Laya Indukuri on 8/8/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import MapKit

class MidpointHelper {
    
    static var midpointLocation: MKMapItem?
    static var middle: CLLocationCoordinate2D?
    
    static var address1Lat: Double?
    static var address1Long: Double?
    static var address2Lat: Double?
    static var address2Long: Double?
    
    static func assignLatLong1() {
        address1Lat = SearchHelper.storedAddress1!.placemark.location!.coordinate.latitude
        address1Long = SearchHelper.storedAddress1!.placemark.location!.coordinate.longitude
    }
    
    static func assignLatLong2() {
        address2Lat = SearchHelper.storedAddress2!.placemark.location!.coordinate.latitude
        address2Long = SearchHelper.storedAddress2!.placemark.location!.coordinate.longitude
    }

    static var midpointLat: Double?
    static var midpointLong: Double?

    static func assignMidpoint() -> CLLocationCoordinate2D{
        midpointLat = Double (address1Lat! + address2Lat!) / 2
        midpointLong = Double (address1Long! + address2Long!) / 2
        middle = CLLocationCoordinate2D(latitude: midpointLat!, longitude: midpointLong!)
        return middle!
        //midpointLocation!.placemark.location!.coordinate.latitude = midpointLat
        //midpointLocation.placemark.location!.coordinate.longitude = midpointLong
        
    }
    
}
