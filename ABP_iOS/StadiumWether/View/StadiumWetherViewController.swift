//
//  StadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit
import NMapsMap
import CoreLocation

class StadiumWetherViewController: UIViewController {
    
    
    
    @IBOutlet var mapView: NMFNaverMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        naverMapViewConfiguration()
        requestLocationPermission()
        
        print("StadiumWetherViewController : viewDidLoad")
    }
    
    
    private func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                self.locationManager.startUpdatingLocation()
                print(self.locationManager.location?.coordinate.latitude as Any)
                print(self.locationManager.location?.coordinate.longitude as Any)
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    private func naverMapViewConfiguration() {
        mapView = NMFNaverMapView(frame: mapView.frame)
        view.addSubview(mapView)
        mapView.showLocationButton = true
    }
    
}


extension StadiumWetherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // the most recent location update is at the end of the array.
        let location: CLLocation = locations[locations.count - 1]
        let _: CLLocationDegrees = location.coordinate.longitude
        let _:CLLocationDegrees = location.coordinate.latitude
        
    }
}

