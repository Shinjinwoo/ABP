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
        
        naverMapViewConfiguration()
        
        locationManager.delegate = self
        //requestGeolocationPermission(locationManager: locationManager)
        
        
        print("StadiumWetherViewController : viewDidLoad")
        
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    
    func naverMapViewConfiguration() {
        
        mapView = NMFNaverMapView(frame: mapView.frame)
        view.addSubview(mapView)
        
        mapView.showLocationButton = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                self.locationManager.startUpdatingLocation()
                print(self.locationManager.location?.coordinate)
            } else {
                print("위치 서비스 Off 상태")
            }
        }
        
    }
    
}


extension StadiumWetherViewController: CLLocationManagerDelegate {
    
}

