//
//  DetailStadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/10/23.
//

import UIKit

class DetailStadiumWetherViewController: UIViewController {
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var selectDate: UILabel!
    @IBOutlet weak var selectHour: UILabel!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var skyLabel: UILabel!
    @IBOutlet weak var oneHourRainFallLabel: UILabel!
    //@IBOutlet weak var oneHourSnowFall: UILabel!
    @IBOutlet weak var POPLable: UILabel!
    @IBOutlet weak var rainImageView: UIImageView!
    
    
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
        print(weatherData)
        setupUI()
    }
    
    func setupUI() {
        firstView.layer.cornerRadius = 16
        secondView.layer.cornerRadius = 16
        thirdView.layer.cornerRadius = 16
        rainImageView.layer.cornerRadius = 16
        temperaturesImage.layer.cornerRadius = 16
        timeView.layer.cornerRadius = 16
        
            
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyyMMdd"

        if let date = dateFormatterInput.date(from: weatherData.fcstDate) {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "yyyy년 MM월 dd일"
            let formattedDate = dateFormatterOutput.string(from: date)
            
            selectDate.text = "일자 : \(formattedDate)"
            
        } else {
            print("날짜를 변환할 수 없습니다.")
        }
        
        
        selectHour.text = "시각 : \(weatherData.fcstTime)"
        
        var skyState = ""
        
        switch weatherData.weatherData.SKY {
        case Sky.Sunny.rawValue : skyState = Sky.Sunny.state
        case Sky.Foggy.rawValue : skyState = Sky.Foggy.state
        case Sky.Cloudy.rawValue : skyState = Sky.Cloudy.state
        default: break
        }
        
        skyLabel.text = skyState
        POPLable.text = "\(weatherData.weatherData.POP)% 확률"
        
        if weatherItem.weatherData.PCP == "강수없음" {
            oneHourRainFallLabel.text = "0.0mm"
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
        
        
        
        // TODO : 하기 데이터 기반으로 화면 구성하기
        
        /**
         
         SKY : 하늘상태
         
         강수확률 {
         POP : 강수확률
         PTY : 강수형태
         
         PCP : 1시간 강수량
         SNO : 1시간 신적설
         }
         
         기온 {
         TMP : 1시간 기온,
         TMN : 일 최저 기온,
         TMX : 일 최고 기온
         }
         
         홈런 {
         VEC : 풍향,
         WSD : 풍속,
         REH : 습도
         }
         */
    }
}
