//
//  StadiumWeatherCell.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/7/23.
//

import UIKit

class StadiumWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var baseTimeLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperaturesLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 16
    }
    
    func configure(_ weatherItem: Weather) {
        
        let weatherData = weatherItem.weatherData
        
        baseTimeLabel.text = weatherItem.fcstTime
        temperaturesLabel.text = "\(weatherData.TMP)°C"
        weatherImage.image = configureWeatherImageWithSummaryLabel(SKY: weatherData.SKY, PTY: weatherData.PTY )
    }
    
    func configureWeatherImageWithSummaryLabel(SKY:String, PTY:String) -> UIImage {
        if SKY == Sky.Sunny.rawValue && PTY == Pty.Sunny.rawValue{
            summaryLabel.text = "맑음(눈,비 소식없음)"
            self.contentView.backgroundColor = .systemOrange
            return (UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal))!
        }
        if SKY == Sky.Foggy.rawValue || SKY == Sky.Cloudy.rawValue {
            switch PTY {
            case Pty.Sunny.rawValue :
                summaryLabel.text = "흐림(눈,비 소식없음)"
                self.contentView.backgroundColor = .systemGray2
                return (UIImage(systemName: "cloud.fill")?.withRenderingMode(.alwaysOriginal))!
                
            case Pty.Raniy.rawValue :
                summaryLabel.text = "흐림(비)"
                self.contentView.backgroundColor = .systemIndigo
                return (UIImage(systemName: "cloud.rain.fill")?.withRenderingMode(.alwaysOriginal))!
                
            case Pty.RainyAndSnowy.rawValue :
                summaryLabel.text = "흐림(눈/비)"
                self.contentView.backgroundColor = .systemTeal
                return (UIImage(systemName: "cloud.rain.fill")?.withRenderingMode(.alwaysOriginal))!
                
            case Pty.Snowy.rawValue :
                summaryLabel.text = "흐림(눈)"
                self.contentView.backgroundColor = .systemTeal
                return (UIImage(systemName: "cloud.snow.fill")?.withRenderingMode(.alwaysOriginal))!
                
            default :
                break
            }
        }
        
        return UIImage(systemName: "sun.horizon.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage(systemName: "sun.horizon.fill")!
    }
}
