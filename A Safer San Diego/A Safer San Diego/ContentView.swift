import SwiftUI // Import SwiftUI for View and StateObject
import CoreLocation


struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                
                Text("Latitude: \(location.coordinate.latitude)")
                Text("Longitude: \(location.coordinate.longitude)")
                
            } else if locationManager.locationDenied {
                Text("Location access is denied. Please enable it in Settings. Alternatively, close application.")
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
            locationManager.checkingAuth()
        }
    }
}

