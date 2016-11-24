//
//  LocationManager.swift
//  ProximityReminders
//
//  Created by Joey on 21/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationManager: NSObject {
    
    //---------------------
    //MARK: Variables
    //---------------------
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var onLocationFix: ((CLPlacemark?, Error?) -> Void)?
    
    //---------------------
    //MARK: Init
    //---------------------
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Ask user permission
        getPermission()
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    
    //Ask user permission for location
    fileprivate func getPermission() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
            //manager.requestAlwaysAuthorization()
        }
    }

    //Get a location from coordinates
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            
            if let error = error {
                completionHandler(nil, error.localizedDescription)
                
            } else if let placemarkArray = placemarks {
                
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                    
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
        })
    }
    
    //MARK: - Reverse location
    func reverseLocation(location: Location, completion: @escaping (_ streetAddress: String, _ houseNumber: String?, _ postalCode: String, _ city: String, _ country: String) -> Void) {
        let locationToReverse = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        self.geoCoder.reverseGeocodeLocation(locationToReverse) { placemarks, error in
            if let placemark = placemarks?.first {
                guard let streedAddress = placemark.thoroughfare, let postalCode = placemark.postalCode, let city = placemark.locality, let country = placemark.country else { return }
                
                let houseNumber = placemark.subThoroughfare
                
                completion(streedAddress, houseNumber, postalCode, city, country)
            }
        }
    }
    
    //Parse location address
    func parseAddress(location: MKPlacemark) -> String {
        
        let firstSpace = (location.subThoroughfare != nil && location.thoroughfare != nil) ? " " : ""
        //Put a comma between street and city/state
        let comma = (location.subThoroughfare != nil || location.thoroughfare != nil) && (location.subAdministrativeArea != nil || location.administrativeArea != nil) ? ", " : ""
        
        let secondSpace = (location.subAdministrativeArea != nil && location.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            //Street number
            location.subThoroughfare ?? "",
            firstSpace,
            //Street name
            location.thoroughfare ?? "",
            comma,
            //City
            location.locality ?? "",
            secondSpace,
            //State
            location.administrativeArea ?? "")
        
        return addressLine
    }
    
    //Drop pin on the map at the selected location and add overlay
    func dropPinZoomIn(placemark: MKPlacemark, mapView: MKMapView) {
        
        //Clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        let location = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        mapView.add(MKCircle(center: location.coordinate, radius: 50))
    }
}

//---------------------
//MARK: Extension
//---------------------
extension LocationManager: CLLocationManagerDelegate {
    
    //------------------------
    //MARK: Location Delegate
    //------------------------
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            
            if let onLocationFix = self.onLocationFix {
                onLocationFix(placemarks?.first, error)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Unresolved error: \(error)")
    }
}
