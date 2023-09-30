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
    
    public var DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14, tilt: 0, heading: 0)
    
    @IBOutlet var mapView: NMFNaverMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                let latitude: Double = self.locationManager.location?.coordinate.latitude ?? 37.5666102
                let longitude: Double = self.locationManager.location?.coordinate.longitude ?? 126.9783881
                print(self.locationManager.location?.coordinate.latitude as Any)
                print(self.locationManager.location?.coordinate.longitude as Any)
                
                self.DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: latitude, lng: longitude), zoom: 14, tilt: 0, heading: 0)
                
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 다음과 같이 뷰가 다 나타난 후에 화면전화를 진행해야한다.
        
        //현재 위치로 카메라 뷰 시작
        mapView.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
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

