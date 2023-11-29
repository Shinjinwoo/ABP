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
        
        
        if let temperature  = Int(weatherData.TMP) {
            if temperature > 0 {
                temperaturesLabel.textColor = UIColor.systemRed
                temperaturesLabel.text = "\(temperature)°C"
            } else {
                temperaturesLabel.textColor = UIColor.systemBlue
                temperaturesLabel.text = "\(temperature)°C"
            }
        } else {
            temperaturesLabel.text = "\(weatherData.TMP)°C"
        }
    
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일 사용
        dateFormatter.dateFormat = "a h시" // 입력된 문자열 형식

        if let date = dateFormatter.date(from: weatherItem.fcstTime) {
            dateFormatter.dateFormat = "HHmm" // 출력할 문자열 형식
            let formattedTime = dateFormatter.string(from: date)
            weatherImage.image = configureWeatherImageWithSummaryLabel(SKY: weatherData.SKY, PTY: weatherData.PTY, fcstTime: formattedTime )
        } else {
            print("시간을 변환할 수 없습니다.")
        }
    }
    
    func configureWeatherImageWithSummaryLabel(SKY: String, PTY: String, fcstTime: String) -> UIImage {
        if SKY == Sky.Sunny.rawValue && PTY == Pty.Sunny.rawValue{
            if  fcstTime >= "0600" && fcstTime <= "1800" {
                summaryLabel.text = "맑음(눈,비 소식없음)"
                self.contentView.backgroundColor = .systemOrange
                return (UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal))!
            } else {
                summaryLabel.text = "맑음(눈,비 소식없음)"
                self.contentView.backgroundColor = .systemCyan
                return (UIImage(systemName: "moon.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.yellow))!
            }
        }
        
        if SKY == Sky.Foggy.rawValue || SKY == Sky.Cloudy.rawValue {
            switch PTY {
            case Pty.Sunny.rawValue :
                summaryLabel.text = "흐림(눈,비 소식없음)"
                self.contentView.backgroundColor = .systemGray2
                return (UIImage(systemName: "cloud.fill")?.withRenderingMode(.alwaysOriginal))!
                
            case Pty.Raniy.rawValue :
                summaryLabel.text = "흐림(비)"
                self.contentView.backgroundColor = .systemTeal
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
