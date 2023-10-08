//
//  StadiumWeatherCell.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/7/23.
//

import UIKit

class StadiumWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var baseTime: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var temperatures: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
    }
    
    
    func configure(_ weatherItem: Weather) {
        baseTime.text = weatherItem.fcstTime
        temperatures.text = "기온 : \(weatherItem.weatherData.TMP)°C"
    }
}
