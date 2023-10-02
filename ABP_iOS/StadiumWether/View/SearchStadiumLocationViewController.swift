//
//  SearchStadiumLocationViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/1/23.
//

import UIKit

class SearchStadiumLocationViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController:nil )
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "주소 검색"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = searchController
    }
}

extension SearchStadiumLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell()
        return cell
    }
}

extension SearchStadiumLocationViewController: UITableViewDelegate {
    
}


