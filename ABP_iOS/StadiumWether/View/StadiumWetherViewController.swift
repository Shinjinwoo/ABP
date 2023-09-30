//
//  StadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit
import NMapsMap
import CoreLocation
import MapKit

class StadiumWetherViewController: UIViewController {
    
    @IBOutlet var mkMapView: MKMapView!
    
    public var DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14, tilt: 0, heading: 0)
    
    @IBOutlet var mapView: NMFNaverMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mkMapViewConfigure()
        requestLocationPermission()
        
        print("StadiumWetherViewController : viewDidLoad")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 다음과 같이 뷰가 다 나타난 후에 화면전화를 진행해야한다.
        
        //현재 위치로 카메라 뷰 시작
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
                
                
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    
    private func mkMapViewConfigure() {
        mkMapView.preferredConfiguration = MKStandardMapConfiguration()
        // 줌 가능 여부
        mkMapView.isZoomEnabled = true
        // 이동 가능 여부
        mkMapView.isScrollEnabled = true
        // 각도 조절 가능 여부 (두 손가락으로 위/아래 슬라이드)
        mkMapView.isPitchEnabled = true
        // 회전 가능 여부
        mkMapView.isRotateEnabled = true
        // 나침판 표시 여부
        mkMapView.showsCompass = true
        // 축척 정보 표시 여부
        mkMapView.showsScale = true
        // 위치 사용 시 사용자의 현재 위치를 표시
        mkMapView.showsUserLocation = true
        
        mkMapView.delegate = self
        
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


extension StadiumWetherViewController: MKMapViewDelegate {
    
}
