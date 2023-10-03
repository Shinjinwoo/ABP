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
    
    @IBOutlet var tableView2: UITableView!
    
    let tableViewCellIdentifier = "SearchStadiumCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.tableView2.register(SearchStadiumCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return completerResults?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "SearchStadiumCellTableViewCell", for: indexPath)
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchStadiumCellTableViewCell", for: indexPath) as? SearchStadiumCellTableViewCell else {
//            
//            print("아아아아악")
//            return UITableViewCell()
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! SearchStadiumCell

        
        let product = completerResults?[indexPath.row]
        cell.configure(localSearchCompletion: product!)
        
        return cell
    }
}




