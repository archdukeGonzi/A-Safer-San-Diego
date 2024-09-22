//
//  userMapLocation.swift
//  A Safer San Diego
//
//  Created by Gonzalo Jr Nunez on 9/19/24.
//

import Foundation
import MapKit

class pinnedLocation: UIViewController, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.bounds
        view.addSubview(mapView)
        
   
    }
    
    
    
    
}
