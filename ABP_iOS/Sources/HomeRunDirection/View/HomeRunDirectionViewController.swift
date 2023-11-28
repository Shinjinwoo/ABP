//
//  HomeRunDirectionViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 11/27/23.
//

import UIKit
import CoreLocation

class HomeRunDirectionViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCL()
        print("HomeRunDirectionViewController-viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCL()
    }
    
    private func setupUI() {
        
        
    }
    
    private func setupCL() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        grantPermission(locationManager)
    }
    
    
    private func grantPermission(_ locationManager:CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    print("위치 서비스 On 상태")
                    self.locationManager.startUpdatingHeading()
                }
            }
            
        case .denied, .restricted:
            print("위치 서비스 Off 상태")
            // 위치 권한이 거부되었거나 제한되었을 때 처리할 작업을 수행합니다.
        default:
            break
        }
    }
}


extension HomeRunDirectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading.trueHeading)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        grantPermission(manager)
    }
}
