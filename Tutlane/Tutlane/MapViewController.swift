//
//  MapViewController.swift
//  Tutlane
//
//  Created by iMacbook on 4/16/19.
//  Copyright © 2019 IOTLink. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let _latitude: CLLocationDegrees = 10.771323
        let _longtitude: CLLocationDegrees = 106.703213
        let latDeltal: CLLocationDegrees = 0.01
        let lngDeltal: CLLocationDegrees = 0.01
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(_latitude, _longtitude)
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDeltal, longitudeDelta: lngDeltal)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Vietnamese"
        annotation.subtitle = "IOLINK"
        self.mapView.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
}
