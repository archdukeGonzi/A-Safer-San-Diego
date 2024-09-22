import SwiftUI
import MapKit
import CoreLocation

// Create a wrapper struct for CLLocation that conforms to Identifiable
struct IdentifiableLocation: Identifiable {
    let id = UUID()  // A unique identifier for each location
    let location: CLLocation
}

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()   // Initialize LocationManager
    
    // State to hold the map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // State to hold an array of IdentifiableLocation for annotations
    @State private var locations: [IdentifiableLocation] = []
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location {
                
                
                // Update region to center on the user's current location
                Map(coordinateRegion: $region, annotationItems: locations) { locationItem in
                    MapMarker(coordinate: locationItem.location.coordinate, tint: .blue)  // Add pin for the user's location
                }
                .onAppear {
                    // When the location is available, center the map on the user's location
                    region.center = location.coordinate
                    // Add the user's current location to the annotations
                    locations = [IdentifiableLocation(location: location)]
                }

                .frame(width: 900, height: 900)
                
                
            } else if locationManager.locationDenied {
                Text("Location access is denied. Please enable it in Settings.")
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                
            } else {
                Text("Requesting location...")
            }
        }
        .padding()
        .onAppear {
            locationManager.checkingAuth() // Check authorization when the view appears
        }
    }
}
