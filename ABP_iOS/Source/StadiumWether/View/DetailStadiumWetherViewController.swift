//
//  DetailStadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/10/23.
//

import UIKit

class DetailStadiumWetherViewController: UIViewController {
    
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var skyLabel: UILabel!
    
    let weatherData:Weather
    
    
    init?(weatherData: Weather,coder:NSCoder) {
        self.weatherData = weatherData
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
