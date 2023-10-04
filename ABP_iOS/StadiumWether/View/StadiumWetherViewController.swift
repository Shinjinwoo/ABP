//
//  StadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import Combine

class StadiumWetherViewController: UIViewController {
    
    @IBOutlet var mkMapView: MKMapView!
    
    let network:Network = Network()
    
    var tableViewController:SearchStadiumLocationViewController! = nil
    //let storyboarded = UIStoryboard(name: "SearchStadiumLocationViewController", bundle: nil)
    let locationManager = CLLocationManager()
    
    var subscriptions = Set<AnyCancellable>()
    
    
    var isMoveCameraByLocate = true
    
    
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    var completerResults: [MKLocalSearchCompletion]?
    
    private var places: MKMapItem? {
        didSet {
            tableViewController.tableView.reloadData()
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        mkMapViewConfigure()
        requestLocationPermission()
        
        //드랍드랍
        
        let testurl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let parameters = [
            "serviceKey": Bundle.main.WEATER_API_KEY,
            "pageNo": "1",
            "numOfRows": "10",
            "dataType": "JSON",
            "base_date": "20231004",
            "base_time": "0500",
            "nx": "55",
            "ny": "127"
        ]
        
        let publisher = AF.request(testurl,parameters: parameters)
            .publishData()
            .map{$0.data!}
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        publisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("요청 성공")
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            } receiveValue: { weatherResponse in
                print(weatherResponse)
            }
            .store(in: &subscriptions)
        
        print("StadiumWetherViewController : viewDidLoad")
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
        let storyboard = UIStoryboard(name: "SearchStadiumLocationViewController", bundle: nil)
        tableViewController = (storyboard.instantiateViewController(withIdentifier: "SearchStadiumLocationViewController") as! SearchStadiumLocationViewController)
        tableViewController.tableView.delegate = self
        
        let searchController = UISearchController(searchResultsController:tableViewController )
        
        
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .address
        searchCompleter?.region = searchRegion
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "주소 검색"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
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


extension StadiumWetherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // the most recent location update is at the end of the array.
        let location: CLLocation = locations[locations.count - 1]
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude:CLLocationDegrees = location.coordinate.latitude
        
        if ( isMoveCameraByLocate == true ) {
            mkMapViewCameraFector(latitude: latitude, longitude: longitude)
        }
    }
}


extension StadiumWetherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let suggestion = completerResults?[indexPath.row] {
            search(for: suggestion)
            
            navigationItem.searchController?.searchBar.placeholder = suggestion.title
        }
    }
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) {
        // 검색 지역 설정
        searchRequest.region = searchRegion
        
        // 검색 유형 설정
        searchRequest.resultTypes = .pointOfInterest
        // MKLocalSearch 생성
        localSearch = MKLocalSearch(request: searchRequest)
        // 비동기로 검색 실행
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                return
            }
            // 검색한 결과 : reponse의 mapItems 값을 가져온다.
            self.places = response?.mapItems[0]
            
            print(places?.placemark.coordinate) // 위경도 가져옴
            
            let latitude: Double = Double((places?.placemark.coordinate.latitude)!)
            let longitude: Double = Double((places?.placemark.coordinate.longitude)!)
            
            navigationItem.searchController?.isActive = false
            
            
            isMoveCameraByLocate = false
            mkMapViewCameraFector(latitude: latitude, longitude: longitude)
        }
    }
}



extension StadiumWetherViewController: MKMapViewDelegate {
    
}

extension StadiumWetherViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerResults = completer.results
        
        print(completerResults)
        
        tableViewController.completerResults = completerResults
        tableViewController.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}

extension StadiumWetherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let keyword = searchController.searchBar.text!
        
        if keyword == "" {
            completerResults = nil
        }
        searchCompleter?.queryFragment = keyword
    }
}

extension StadiumWetherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else { return }
        print(keyword)
        
        if keyword == "" {
            completerResults = nil
        }
        searchCompleter?.queryFragment = keyword
        
    }
}
