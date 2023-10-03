//
//  StadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/25/23.
//

import UIKit
import CoreLocation
import MapKit

class StadiumWetherViewController: UIViewController {
    
    @IBOutlet var mkMapView: MKMapView!
    
    var tableViewController:SearchStadiumLocationViewController! = nil
    let storyboarded = UIStoryboard(name: "SearchStadiumLocationViewController", bundle: nil)
    
    let locationManager = CLLocationManager()
    
    
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
        

        tableViewController = (storyboarded.instantiateViewController(withIdentifier: "SearchStadiumLocationViewController") as! SearchStadiumLocationViewController)
        
        //let viewController =
        
        setUpUI()
        mkMapViewConfigure()
        requestLocationPermission()
        
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
    
        
        let searchController = UISearchController(searchResultsController:tableViewController )
        
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .address // 혹시 값이 안날아온다면 이건 주석처리 해주세요
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
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchStadiumLocationViewController") as! SearchStadiumLocationViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        
        return true
    }
}
