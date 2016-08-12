//
//  MapViewController.swift
//  Meet-Halfway
//
//  Created by Laya Indukuri on 7/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import YelpAPI
//import SwiftyJSON

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var selectedPin:MKPlacemark? = nil
    
    //Zooming stuff
    
    
    
    
    let locationManager = CLLocationManager()
    
    var address1 : String!
    var address2 : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let span = MKCoordinateSpanMake(0.075, 0.075)
//        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
//        mapView.setRegion(region, animated: true)
        
        locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Address1 Pin Implementation
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = SearchHelper.storedAddress1!.placemark.coordinate
        //annotation1.title = SearchHelper.storedAddress1!.name
        annotation1.title = "Me"
        self.mapView.addAnnotation(annotation1)
        
        //Address2 Pin Implementation
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = SearchHelper.storedAddress2!.placemark.coordinate
        //annotation2.title = SearchHelper.storedAddress2?.name
        annotation2.title = "Friend"
        self.mapView.addAnnotation(annotation2)
        
        //Midpoint Pin Implementation
        //let annotation3 = MKPointAnnotation()
        let annotation3 = ColorPointAnnotation(pinColor: UIColor.orangeColor())
        //annotation3.pinTintColor = UIColor.orangeColor()
        annotation3.coordinate = MidpointHelper.assignMidpoint()
        annotation3.title = "Midpoint!"
        self.mapView.addAnnotation(annotation3)
        
        //Changing color of pins
//        let annotation = ColorPointAnnotation(pinColor: UIColor.blueColor())
//        annotation.coordinate = coordinate
//        annotation.title = "title"
//        annotation.subtitle = "subtitle"
//        self.mapView.addAnnotation(annotation)
        
        
        
        
        //Yelp Pins
        YelpHelper.yelpAccess { businesses in
            let coordinates: [CLLocationCoordinate2D] = businesses.map { business in
                
                let ylpCoordinate = business.location.coordinate!
                let ylpCoordinateLatitude = ylpCoordinate.latitude
                let ylpCoordinateLongitude = ylpCoordinate.longitude
                let ylp = CLLocationCoordinate2D(latitude: ylpCoordinateLatitude, longitude: ylpCoordinateLongitude)
                
                
                let yelpAnnotation = ColorPointAnnotation(pinColor: UIColor.blueColor())
                yelpAnnotation.coordinate = ylp
                print(business.name)
                yelpAnnotation.title = business.name
                yelpAnnotation.subtitle = business.location.displayAddress.reduce("") { return "\($0!)\($1) " }
    
                self.mapView.addAnnotation(yelpAnnotation)
                return CLLocationCoordinate2D(latitude: ylpCoordinate.latitude, longitude: ylpCoordinate.longitude)
            }
            
            // Weird hack around displaying added annotations
//            let annotations = self.mapView.annotations
//            self.mapView.removeAnnotations(annotations)
//            self.mapView.addAnnotations(annotations)
        }
        
//        YelpHelper.yelpAccess({ (businesses: [YLPBusiness]) -> Void in
//            // run on main thread
//            dispatch_async(dispatch_get_main_queue()) {
//                self.mapView.reloadInputViews()
//            }
//        })
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(annotation1.coordinate, 100000, 100000)
        self.mapView.setRegion(zoomRegion, animated: true)
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.mapType = .Standard
        
        locationManager.startUpdatingLocation()
        
    }
    
    //Changes color of pin view
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            //Adds info button to pins
            let rightButton: AnyObject! = UIButton(type: UIButtonType.DetailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
            
            //Changes color of pins
            if let colorPointAnnotation = annotation as? ColorPointAnnotation {
                pinView?.pinTintColor = colorPointAnnotation.pinColor
            }
            
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegueWithIdentifier("yelpExtraInfo", sender: self)
            print("Going to the next VC!")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            print("location:: (location)")
            locationManager.stopUpdatingLocation()
        }

    }

}

extension MapViewController : CLLocationManagerDelegate {
    //Get user's current location
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}



