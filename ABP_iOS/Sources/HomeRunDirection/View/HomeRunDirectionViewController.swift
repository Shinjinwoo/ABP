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
    
    @IBOutlet weak var bottomView: UIView!
    
    
    var locationManager = CLLocationManager()
    
    let viewModel = StadiumWeatherViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var windImageView: UIImageView!
    @IBOutlet weak var northPointedArrow: UIImageView!
    
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windVelocityLabel: UILabel!
    @IBOutlet weak var humdityLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var indicatorView: UIView!
    var isFirtstCallHead = true
    
    lazy var activityIndicator: UIActivityIndicatorView = { // indicator가 사용될 때까지 인스턴스를 생성하지 않도록 lazy로 선언
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = indicatorView.frame
        activityIndicator.style = UIActivityIndicatorView.Style.large // indicator의 스타일 설정, large와 medium이 있음
        activityIndicator.startAnimating() // indicator 실행
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.delegate = nil // delegate에 nil 할당
        locationManager.stopUpdatingLocation() // 위치 업데이트 중지
        locationManager.stopUpdatingHeading() // 방향 정보 업데이트 중지
        activityIndicator.startAnimating()
        indicatorView.isHidden = false
    }
    
    deinit {
        locationManager.delegate = nil // delegate에 nil 할당
        locationManager.stopUpdatingLocation() // 위치 업데이트 중지
        locationManager.stopUpdatingHeading() // 방향 정보 업데이트 중지
    }
    
    private func setupUI() {
        
        self.bottomView.layer.cornerRadius = 16
        self.bottomView.backgroundColor = .systemBackground
        
        for case let subview in stackView.arrangedSubviews {
            subview.layer.cornerRadius = 16 // 설정하고 싶은 radius 값
            subview.layer.masksToBounds = true // 설정한 radius 값으로 뷰를 자르도록 설정
            //subview.backgroundColor = .systemGray4
        }
        
        indicatorView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor)
        ])
    }
    
    private func bind() {
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink {list in
                self.showWeatherInfo(weather: list?[0])
                self.indicatorView.isHidden = true
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
    
    
    private func showWeatherInfo(weather: Weather?) {
        self.activityIndicator.stopAnimating()
        if let degreeStr = weather?.weatherData.VEC {
            if let degreeFloat = Float(degreeStr), let degree = CGFloat(exactly: degreeFloat) {
                
                bottomView.translatesAutoresizingMaskIntoConstraints = false
                
                UIView.animate(withDuration: 0.5) {
                    let rotationAngle = CGFloat(degree * Double.pi / 180)
                    self.windImageView.transform = CGAffineTransform(rotationAngle: rotationAngle).translatedBy(x: self.northPointedArrow.bounds.minX,
                                                                                                                y: self.northPointedArrow.bounds.minY)
                    NSLayoutConstraint.activate([
                        self.bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                        self.bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                        self.bottomView.topAnchor.constraint(equalTo: self.indicatorView.topAnchor, constant: 16),
                        self.bottomView.heightAnchor.constraint(equalToConstant: 200)
                    ])
                    self.view.layoutIfNeeded()
                    
                    self.windDirectionLabel.text = "\(degreeStr)°"
                    self.windVelocityLabel.text = "\(weather?.weatherData.WSD ?? "0" )m/s"
                    self.humdityLabel.text = "\(weather?.weatherData.REH ?? "0")%"
                }
            } else {
                print("문자열을 CGFloat으로 변환할 수 없습니다.")
            }
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
