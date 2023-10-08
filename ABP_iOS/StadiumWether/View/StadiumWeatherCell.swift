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
        baseTime.text = convertTimeForKor(formatHHmmTime: weatherItem.fcstTime)
        temperatures.text = "기온 : \(weatherItem.weatherData.TMP)°C"
    }
    
    
    func convertTimeForKor(formatHHmmTime:String) ->String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HHmm" // 입력 문자열의 포맷
        let date = inputFormatter.date(from: formatHHmmTime)
            // 출력 형식 지정
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "a h시"  // 원하는 출력 포맷 (AM/PM)
        outputFormatter.locale = Locale(identifier: "ko_KR")
            // Date를 문자열로 변환
        let formattedTimeString = outputFormatter.string(from: date!)
        
        
        return formattedTimeString
    }
    
}
