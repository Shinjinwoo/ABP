//
//  SearchStadiumCellTableViewCell.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/2/23.
//

import UIKit
import MapKit

class SearchStadiumCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func configure(localSearchCompletion :MKLocalSearchCompletion) {
        
        title.text = localSearchCompletion.title
        subTitle.text = localSearchCompletion.subtitle
    }

}
