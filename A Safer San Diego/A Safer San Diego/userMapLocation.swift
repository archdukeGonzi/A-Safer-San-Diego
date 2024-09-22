import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, ObservableObject {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager: LocationManager

    // Dependency injection of the location manager
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the mapView delegate
        mapView.delegate = self
        
        // Set up the map to show the user’s location
        mapView.showsUserLocation = true
        
        // Observe changes in the locationManager's location
        observeLocationChanges()
    }
    
    // Function to pin the user's location on the map
    func pinUserLocation() {
        guard let userLocation = locationManager.location else {
            print("User location not available")
            return
        }
        
        // Create an annotation for the user's location
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = "You are here"  // Optional title for the pin
        
        // Add the annotation to the map view
        mapView.addAnnotation(annotation)
        
        // Optionally, center the map on the user's location
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    // Observe changes in the locationManager's location property
    func observeLocationChanges() {
        locationManager.$location.sink { [weak self] location in
            if let _ = location {
                self?.pinUserLocation()  // Call the pinUserLocation function when the location changes
            }
        }
    }
}

