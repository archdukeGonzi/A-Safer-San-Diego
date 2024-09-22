import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?                        // Publish the user's location
    @Published var authorizationStatus: CLAuthorizationStatus?  // Track authorization status
    @Published var locationDenied = false                       // Track if location permission is denied
    
    override init() {
        super.init()
        locationManager.delegate = self
        checkingAuth()                            // check authorization when initializing
    }
    
    func checkingAuth() {
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // Request location when app is in use
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation() // Start updating location
            
        case .denied, .restricted:
            locationDenied = true
            print("Location access is denied or restricted.")
            
        @unknown default:
            print("Unexpected authorization status.")
        }
    }
    
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.location = location
            }
        }
    }
    
    
    // Handle location authorization status change
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkingAuth() // Recheck permissions when they change
    }
    
    
    // Fialed to update location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update location: \(error)")
    }
}

