////  pedestrianLocation.swift
//  A Safer San Diego
//
//  Created by Gonzalo Jr Nunez on 9/11/24.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    let locationManager = CLLocationManager()
    @Published var location: CLLocation? // Publish the user's location
    @Published var authorizationStatus: CLAuthorizationStatus? // Track authorization status
    @Published var locationDenied = false // Track if location permission is denied
    
    override init() {
        super.init()
        locationManager.delegate = self
        checkingAuth() // Automatically check authorization when initializing
    }
    
    func checkingAuth() {
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Request location when app is in use
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            locationDenied = true
            print("Location access is denied or restricted.")
            
        @unknown default:
            print("Unexpected authorization status.")
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        checkingAuth() // Recheck authorization after a change
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}


