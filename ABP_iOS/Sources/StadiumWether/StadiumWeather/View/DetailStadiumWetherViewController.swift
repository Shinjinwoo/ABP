//
//  DetailStadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/10/23.
//

import UIKit

class DetailStadiumWetherViewController: UIViewController {
    
    
    /**
     헤더 시간 뷰
     */
    @IBOutlet weak var headerTimeView: UIView!
    @IBOutlet weak var selectDate: UILabel!
    @IBOutlet weak var selectHour: UILabel!
    /**
     하늘 상태 뷰
     */
    @IBOutlet weak var skyInfoView: UIView!
    @IBOutlet weak var skyLabel: UILabel!
    @IBOutlet weak var skyImageView: UIImageView!
    /**
     강수 정보 뷰
     */
    @IBOutlet weak var rainInfoView: UIView!
    @IBOutlet weak var oneHourRainFallLabel: UILabel!
    @IBOutlet weak var POPLable: UILabel!
    @IBOutlet weak var rainImageView: UIImageView!
    /**
     기온 정보 뷰
     */
    @IBOutlet weak var tempeInfoView: UIView!
    @IBOutlet weak var temperaturesImage: UIImageView!
    @IBOutlet weak var temperaturesLabel: UILabel!
    
    
    let weatherItem:Weather
    
    
    init?(weatherItem: Weather,coder:NSCoder) {
        self.weatherItem = weatherItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(weatherItem)
        setupUI()
    }
    
    func setupUI() {
        
        headerTimeView.layer.cornerRadius = 16
        
        skyInfoView.layer.cornerRadius = 16
        skyImageView.layer.cornerRadius = 16
        
        rainInfoView.layer.cornerRadius = 16
        rainImageView.layer.cornerRadius = 16
        
        tempeInfoView.layer.cornerRadius = 16
        temperaturesImage.layer.cornerRadius = 16
            
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyyMMdd"

        if let date = dateFormatterInput.date(from: weatherItem.fcstDate) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "yyyy년 MM월 dd일"
            let formattedDate = dateFormatterOutput.string(from: date)
            
            selectDate.text = "일자 : \(formattedDate)"
            
        } else {
            print("날짜를 변환할 수 없습니다.")
        }
        
        
        selectHour.text = "시각 : \(weatherItem.fcstTime)"
        
        var skyState = ""
        
        switch weatherItem.weatherData.SKY {
        case Sky.Sunny.rawValue : skyState = Sky.Sunny.state
        case Sky.Foggy.rawValue : skyState = Sky.Foggy.state
        case Sky.Cloudy.rawValue : skyState = Sky.Cloudy.state
        default: break
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일 사용
        dateFormatter.dateFormat = "a h시" // 입력된 문자열 형식

        if let date = dateFormatter.date(from: weatherItem.fcstTime) {
            dateFormatter.dateFormat = "HHmm" // 출력할 문자열 형식
            let formattedTime = dateFormatter.string(from: date)
            skyImageView.image = self.configureWeatherImage(SKY:weatherItem.weatherData.SKY , PTY: weatherItem.weatherData.PTY, fcstTime:formattedTime )
        } else {
            print("시간을 변환할 수 없습니다.")
        }
        
        
        skyLabel.text = skyState
        POPLable.text = "\(weatherItem.weatherData.POP)% 확률"
        
        if weatherItem.weatherData.PCP == "강수없음" {
            oneHourRainFallLabel.text = "강수량 0.0mm"
        } else {
            oneHourRainFallLabel.text = "강수량 \(weatherItem.weatherData.PCP)mm"
        }
        
        
        if let temperature = Int(weatherItem.weatherData.TMP) {
            switch temperature {
            case 0...50 : 
                temperaturesLabel.textColor = UIColor.red
                temperaturesLabel.text = "영상 \(temperature)℃"
            default : 
                temperaturesLabel.textColor = UIColor.systemBlue
                temperaturesLabel.text = "영하 \(temperature)℃"
            }
        }
    }
}
