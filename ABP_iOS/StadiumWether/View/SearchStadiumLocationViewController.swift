//
//  SearchStadiumLocationViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/1/23.
//

import UIKit
import MapKit

class SearchStadiumLocationViewController: UITableViewController {
    
    
    var completerResults: [MKLocalSearchCompletion]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return completerResults?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchStadiumCell", for: indexPath) as? SearchStadiumCell else {
            
            return UITableViewCell()
        }
        
        if let suggestion = completerResults?[indexPath.row] {
            cell.configure(localSearchCompletion: suggestion)
        }
        
        return cell
    }
    
}




