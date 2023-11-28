//
//  HomeRunDirectionViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 11/27/23.
//

import UIKit
import CoreLocation
import Combine

class HomeRunDirectionViewController: UIViewController {
    
    @IBOutlet weak var compassBorderImageView: UIImageView!
    
    var locationManager = CLLocationManager()
    
    let viewModel = StadiumWeatherViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var northPointedArrow: UIImageView!
    
    var isFirtstCallHead = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        
        print("HomeRunDirectionViewController-viewDidLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCL()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.delegate = nil
        isFirtstCallHead = true
    }
    
    private func setupUI() {
        
        
        
    }
    
    private func bind() {
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink {list in
                if let degreeStr = list?[0].weatherData.VEC {
                    if let degreeFloat = Float(degreeStr), let degree = CGFloat(exactly: degreeFloat) {
                        print(degree) // 변환된 CGFloat 값 출력
                        UIView.animate(withDuration: 1) {
                            let rotationAngle = CGFloat(degree * Double.pi / 180)
                            
                            self.windImageView.transform = CGAffineTransform(rotationAngle: rotationAngle).translatedBy(x: self.northPointedArrow.bounds.minX,
                                                                                                                        y: self.northPointedArrow.bounds.minY)
                        }
                    } else {
                        print("문자열을 CGFloat으로 변환할 수 없습니다.")
                    }
                }
            }.store(in: &subscriptions)
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
                    locationManager.startUpdatingHeading()
                    locationManager.startUpdatingLocation()
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
        if isFirtstCallHead {
            UIView.animate(withDuration: 0.5) {
                let heading = 0 - newHeading.trueHeading.degreesToRadians
                let angle = CGFloat(0.degreesToRadians + heading)
                self.containerView.transform = CGAffineTransform(rotationAngle: angle)
            }
            isFirtstCallHead = false
        } else {
            if Int(newHeading.trueHeading) % 2 == 0 {
                UIView.animate(withDuration: 0.5) {
                    let heading = 0 - newHeading.trueHeading.degreesToRadians
                    let angle = CGFloat(0.degreesToRadians + heading)
                    self.containerView.transform = CGAffineTransform(rotationAngle: angle)
                }
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        grantPermission(manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location: CLLocation = locations[locations.count - 1]
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude:CLLocationDegrees = location.coordinate.latitude
        
        viewModel.fetchWeatherAPI(latitude: latitude, longitude: longitude)
    }
}

extension HomeRunDirectionViewController:UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 선택된 탭의 인덱스나 정보에 따라 원하는 작업 수행
        if let selectedTabIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
            print("선택된 탭의 인덱스: \(selectedTabIndex)")
            // 선택된 탭에 따른 동작 수행
        }
    }
}
