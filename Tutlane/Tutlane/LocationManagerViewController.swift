//
//  LocationManagerViewController.swift
//  Tutlane
//
//  Created by iMacbook on 4/18/19.
//  Copyright © 2019 IOTLink. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longtitude: UILabel!
    @IBOutlet weak var addressAtHere: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var btnTagButton: UIButton!
    @IBOutlet weak var btnGetButton: UIButton!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: NSError?
    let geocoder: CLGeocoder? = nil
    var placeMark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func actionMyLocation(_ sender: Any) {
        
        let authStatus = CLLocationManager.authorizationStatus()
        print (authStatus)
        if authStatus == .notDetermined {
            print(".notDetermined")
            locationManager.requestWhenInUseAuthorization()
            return
        }
        if authStatus == .denied || authStatus == .restricted {
            print(".denied or .restricted")
            showLocationServicesDeniedAlert()
            return
        }
        if updatingLocation {
            stopLocationManager()
        }
        else {
            location = nil
            lastLocationError = nil
            placeMark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
        startLocationManager()
    }
    
    func configureGetButton() {
        if updatingLocation {
            btnGetButton.setTitle("Stop", for: .normal)
        }
        else {
            btnGetButton.setTitle("Get My Location", for: .normal)
        }
    }

    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Diabeled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer {
                timer.invalidate()
            }
        }
    }

    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(LocationManagerViewController.didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    @objc func didTimeOut(){
        print(" *** Time out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationErrorDomain", code: 1, userInfo: nil)
            updateLabels()
            configureGetButton()
        }
    }

    func stringFromPlacemark(placeMark: CLPlacemark) -> String{
        var line1 = ""
        if let s = placeMark.subThoroughfare {
            line1 += s + " "
        }
        if let s = placeMark.thoroughfare {
            line1 += s
        }
        var line2 = ""
        if let s = placeMark.locality {
            line2 = s + " "
        }
        if let s = placeMark.administrativeArea {
            line2 = s + " "
        }
        if let s = placeMark.postalCode {
            line2 += s
        }
        return line1 + "\n" + line2
    }
    
    func updateLabels() {
        if let location = location {
            latitude.text = String(format: "%.8f", location.coordinate.latitude)
            longtitude.text = String(format: "%.8f", location.coordinate.longitude)
            if let placeMark = placeMark {
                addressAtHere.text = stringFromPlacemark(placeMark: placeMark)
            }
            else if performingReverseGeocoding {
                addressAtHere.text = "Seaching for Adrees..."
            }
            else if lastGeocodingError != nil {
                addressAtHere.text = "Error Finding address"
            }
            else {
                addressAtHere.text = "No Address Found"
            }
        }
        else {
            latitude.text = ""
            longtitude.text = ""
            addressAtHere.text = ""
            btnTagButton.isHidden = true
            let statusMassage: String

            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue{
                    statusMassage = "Location Service Disabeled"
                }
                else {
                    statusMassage = "Searching..."
                }
            }
            else if !CLLocationManager.locationServicesEnabled(){
                statusMassage = "Location Service Disabeled"
            }
            else if updatingLocation {
                statusMassage = "Seaching..."
            }
            else {
                statusMassage = "Tap 'Get My Location' to Start"
            }
            messageLabel.text = statusMassage
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        if let err = error as? CLError {
            if err.code.rawValue == CLError.locationUnknown.rawValue {
                return
            }
        }
        lastLocationError = error as NSError
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        print("location : \(String(describing: location))")
        print("newLocations \(newLocation!.timestamp.timeIntervalSinceNow)")
        print("newLocations \(newLocation!.horizontalAccuracy)")
        if newLocation!.timestamp.timeIntervalSinceNow < -5 {
            print("*** ERROR <5 ***")
            return
        }
        if newLocation!.horizontalAccuracy < 0 {
            print("*** ERROR <0 ***")
            return
        }
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location {
            distance = (newLocation?.distance(from: location))!
        }
        if location == nil || location!.horizontalAccuracy > newLocation!.horizontalAccuracy{
            lastLocationError = nil
            location = newLocation
            updateLabels()
        }
        if newLocation!.horizontalAccuracy <= locationManager.desiredAccuracy {
            print ("*** We're done")
            stopLocationManager()
            configureGetButton()
            if distance > 0 {
                performingReverseGeocoding = false
            }
        }
        if !performingReverseGeocoding {
            print("*** Going to geocode")
            performingReverseGeocoding = true
            geocoder?.reverseGeocodeLocation(newLocation!, completionHandler: {(placeMarks, error) in
                self.lastGeocodingError = error as NSError?
                if error == nil, let p = placeMarks, !p.isEmpty {
                    self.placeMark = p.last
                }
                else {
                    self.placeMark = nil
                }
                self.performingReverseGeocoding = false
                self.updateLabels()
                })
        }
        else if distance < 1.0 {
            let timeInterval = newLocation?.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval! > 10 {
                print("*** Force done!")
                stopLocationManager()
                updateLabels()
                configureGetButton()
            }
        }
    }
}
