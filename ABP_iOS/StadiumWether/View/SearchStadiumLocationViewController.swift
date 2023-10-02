//
//  SearchStadiumLocationViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/1/23.
//

import UIKit
import MapKit

class SearchStadiumLocationViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    var completerResults: [MKLocalSearchCompletion]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

extension SearchStadiumLocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchStadiumCellTableViewCell", for: indexPath)
        let product = completerResults?[indexPath.row]
        
        cell.textLabel?.text = product?.title
        return cell
    }
}

extension SearchStadiumLocationViewController: UITableViewDelegate {
    
}


