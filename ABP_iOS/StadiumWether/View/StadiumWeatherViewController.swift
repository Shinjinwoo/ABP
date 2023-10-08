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
    
    typealias Item = Weather
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var subscriptions = Set<AnyCancellable>()
    var subscriptions2 = Set<AnyCancellable>()
    
    let weatherViewModel =  StadiumWeatherViewModel()
    let addressViewModel =  StadiumAddressViewModel()
    
    let network:Network = Network()
    let locationManager = CLLocationManager()
    
    var isMoveCameraByLocate = true
    
    
    private var searchCompleter: MKLocalSearchCompleter?
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        bind()
        mkMapViewConfigure()
        requestLocationPermission()
        configureCollectionView()
        
        
        
        print("StadiumWetherViewController : viewDidLoad")
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
        
//        $serachContorllerPlaceholder
//            .receive(on: RunLoop.main)
//            .sink { value in
//                print(value)
//                //self.navigationItem.searchController?.searchBar.placeholder = value
//            }.store(in: &subscriptions2)
        
        addressViewModel.$item
            .receive(on: RunLoop.main)
            .sink { [unowned self] value in
                if value != nil {
                    self.navigationItem.searchController?.searchBar.placeholder = value!.jibunAddress
                    self.mkMapViewCameraFector(latitude: value!.latitude, longitude: value!.longitude)
                    weatherViewModel.requestWeatherAPI(latitude: value!.latitude, longitude: value!.longitude)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // searchCompleter는 강한 참조이므로
        searchCompleter = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 다음과 같이 뷰가 다 나타난 후에 화면전화를 진행해야한다.
        
        //현재 위치로 카메라 뷰 시작
        
    }
    
    
    private func setUpUI() {
        //self.navigationItem.title = "경기장 날씨검색"
        
        let searchController = UISearchController(searchResultsController:nil )
        
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.resultTypes = .address
        searchCompleter?.region = searchRegion
        
        searchController.searchBar.placeholder = "주소 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        collectionView.addSubview(activityIndicator)
        
        self.navigationItem.searchController = searchController
    }
    
    
    private func configureCollectionView() {
        // presentation
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StadiumWeatherCell", for: indexPath) as? StadiumWeatherCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        // layer
        collectionView.collectionViewLayout = layout()
        collectionView.delegate = self
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 10
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.50))
        //let groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: itemLayout, count:   3)
        let groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize:groupSize, repeatingSubitem:itemLayout,count:2)
        groupLayout.interItemSpacing = .fixed(spacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: groupLayout)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        
        grantLocationPermission()
    }
    
    private func grantLocationPermission() {
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
            weatherViewModel.requestWeatherAPI(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    print("위치 서비스 On 상태")
                    self.locationManager.startUpdatingLocation()
                    
                    print(self.locationManager.location?.coordinate.latitude as Any)
                    print(self.locationManager.location?.coordinate.longitude as Any)
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
        print(collectionView)
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
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        print(keyword)
        
        if keyword == "" {
            completerResults = nil
        }
        searchCompleter?.queryFragment = keyword
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let storyboard = UIStoryboard(name: "StadiumWeatherViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchStadiumWKWebViewController") as! SearchStadiumWKWebViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        return true
    }
}


