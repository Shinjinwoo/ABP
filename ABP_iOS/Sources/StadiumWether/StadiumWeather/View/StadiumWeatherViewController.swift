//
//  StadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit
import CoreLocation
import MapKit
import WebKit
import Combine


class StadiumWeatherViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var mkMapView: MKMapView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    typealias Item = Weather
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var subscriptions = Set<AnyCancellable>()
    var subscriptions2 = Set<AnyCancellable>()
    
    let weatherViewModel =  StadiumWeatherViewModel()
    let addressViewModel =  StadiumAddressViewModel()
    
    let locationManager = CLLocationManager()
    
    var isMoveCameraByLocate = true
    
    
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    var completerResults: [MKLocalSearchCompletion]?
    
    lazy var activityIndicator: UIActivityIndicatorView = { // indicator가 사용될 때까지 인스턴스를 생성하지 않도록 lazy로 선언
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = collectionView.frame
        activityIndicator.style = UIActivityIndicatorView.Style.large // indicator의 스타일 설정, large와 medium이 있음
        activityIndicator.startAnimating() // indicator 실행
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
    
    override func loadView() {
        super.loadView()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        bind()
        mkMapViewConfigure()
        requestLocationPermission()
        configureCollectionView()
        
        
        print("StadiumWetherViewController : viewDidLoad")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.delegate = nil // delegate에 nil 할당
        locationManager.stopUpdatingLocation() // 위치 업데이트 중지
        locationManager.stopUpdatingHeading() // 방향 정보 업데이트 중지
    }
    
    deinit {
        locationManager.delegate = nil // delegate에 nil 할당
        locationManager.stopUpdatingLocation() // 위치 업데이트 중지
        locationManager.stopUpdatingHeading() // 방향 정보 업데이트 중지
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        grantLocationPermission(locationManager)
    }
    
    func bind() {
        weatherViewModel.$items
            .receive(on: RunLoop.main)
            .sink { [unowned self] list in
                if list != nil {
                    self.weatherSectionItems(list!)
                    self.stopActivityIndicator()
                }
            }.store(in: &subscriptions)
        
        weatherViewModel.$statusMsg
            .receive(on: RunLoop.main)
            .sink { statusMsg in
                if statusMsg != nil {
                    let alert = UIAlertController(title: "기상 API 통신에러",
                                                  message: "통신 에러입니다.\n에러코드 : \(statusMsg!.resultCode)\n 서버 에러메시지 :\(statusMsg!.resultMsg)",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in  }))
                    
                    self.present(alert, animated: true)
                    self.stopActivityIndicator()
                }
            }.store(in: &subscriptions)
        
        weatherViewModel.$errorFlag
            .receive(on: RunLoop.main)
            .sink { errorFlag in
                if errorFlag != nil {
                    
                    let alert = UIAlertController(title: "기상 API 통신에러", message: "통신 에러입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in  }))
                    
                    self.present(alert, animated: true)
                    self.stopActivityIndicator()
                }
            }.store(in: &subscriptions)
        
        weatherViewModel.$selectedItem
            .receive(on: RunLoop.main)
            .sink { weatherItem in
                if weatherItem != nil {
                    
                    let storyboard = UIStoryboard(name: "DetailStadiumWetherViewController", bundle: nil)
                    
                    //let vc = storyboard.instantiateViewController(withIdentifier: "DetailStadiumWetherViewController") as! DetailStadiumWetherViewController
                    let vc = storyboard.instantiateViewController(identifier: "DetailStadiumWetherViewController",creator: { creator in
                        let viewController = DetailStadiumWetherViewController(weatherItem: weatherItem!, coder: creator)
                        return viewController
                    })
                    
                    //self.navigationController?.pushViewController(vc, animated: true)
                    self.present(vc, animated: true)
                }
            }.store(in: &subscriptions)
        
        addressViewModel.$item
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value != nil {
                    let locateInfo = value!
                    
                    self.navigationItem.searchController?.searchBar.placeholder = locateInfo.jibunAddress
                    self.mkMapViewCameraFector(latitude: locateInfo.latitude, longitude: locateInfo.longitude)
                    self.addAnnotationToMapView(longitudeValue: locateInfo.longitude, latitudeValue: locateInfo.latitude,title: locateInfo.jibunAddress,subTitle: locateInfo.roadAddress)
                    weatherViewModel.fetchWeatherAPI(latitude: locateInfo.latitude, longitude: locateInfo.longitude)
                    self.startActivityIndicator()
                }
            }.store(in: &subscriptions2)
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating() // indicator 종료
    }
    
    func startActivityIndicator(){
        activityIndicator.startAnimating()
    }
    
    private func weatherSectionItems(_ items: [Item], to section: Section = .main) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot)
    }
    
    private func setUpUI() {
        //self.navigationItem.title = "경기장 날씨검색"
        
        let searchController = UISearchController(searchResultsController:nil )
        
        searchController.searchBar.placeholder = "주소 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        
        
        collectionView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])

        
        pageControl.numberOfPages = 5
        
        self.navigationItem.searchController = searchController
    }
    
    
    private func configureCollectionView() {
        // presentation
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StadiumWeatherCell", for: indexPath) as? StadiumWeatherCell else {
                return nil
            }
            
            cell.configure(item)

            cell.backgroundColor = UIColor.gray
            
            return cell
        })
        
        
        let layout = layout()
        collectionView.collectionViewLayout = layout
        // layer
        collectionView.delegate = self
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
    
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20

        section.visibleItemsInvalidationHandler = { (items, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            //print("--> \(index)")
            self.pageControl.currentPage = index
        }

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    private func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        
        //grantLocationPermission(locationManager)
    }
    
    private func grantLocationPermission(_ locationManager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    print("위치 서비스 On 상태")
                    self.locationManager.startUpdatingLocation()
                    
                    print("latitude : \(self.locationManager.location?.coordinate.latitude as Any)")
                    print("longitude : \(self.locationManager.location?.coordinate.longitude as Any)")
                    
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

//로케이션 정보 업데이트 시 표시
extension StadiumWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // the most recent location update is at the end of the array.
        let location: CLLocation = locations[locations.count - 1]
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude:CLLocationDegrees = location.coordinate.latitude
        
        if ( isMoveCameraByLocate == true ) {
            mkMapViewCameraFector(latitude: latitude, longitude: longitude)
            weatherViewModel.fetchWeatherAPI(latitude: latitude, longitude: longitude)
            self.startActivityIndicator()
        }
    }
    
    func addAnnotationToMapView(longitudeValue: Double,latitudeValue: Double,title: String, subTitle: String = "") {
        mkMapView.removeAnnotations(mkMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue) // 위도, 경도 설정
        annotation.title = title // 제목 설정
        annotation.subtitle = subTitle // 부제목 설정
        mkMapView.addAnnotation(annotation) // 맵뷰에 어노테이션 추가
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    print("위치 서비스 On 상태")
                    self.locationManager.startUpdatingLocation()
                    
                    print("latitude : \(self.locationManager.location?.coordinate.latitude as Any)")
                    print("longitude : \(self.locationManager.location?.coordinate.longitude as Any)")
                    
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

extension StadiumWeatherViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        weatherViewModel.didSelect(at: indexPath)
    }
}

extension StadiumWeatherViewController: MKMapViewDelegate {
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
    
    func mkMapViewCameraFector(latitude: Double,longitude: Double ) {
        
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        
        mkMapView.setRegion(region, animated: true)
    }
    
}


extension StadiumWeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let storyboard = UIStoryboard(name: "SearchAddressViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchAddressViewController") as! SearchAddressViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        return true
    }
}


