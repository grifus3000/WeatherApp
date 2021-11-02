//
//  LocationService.swift
//  WeatherApp
//
//  Created by Grifus on 25.10.2021.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    
    override init() {
        super.init()
        start()
    }
    
    let locationManager = CLLocationManager()
    
    func start() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func getLocation() -> (lat: Double?, lon: Double?) {
        let coordinates = locationManager.location?.coordinate
        
        guard var lat = coordinates?.latitude, var lon = coordinates?.longitude else { return (nil, nil) }
        
        lat = Double(lat)
        lon = Double(lon)
        
        return(lat, lon)
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
}
