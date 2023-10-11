//
//  DetailStadiumWetherViewController.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/10/23.
//

import UIKit

class DetailStadiumWetherViewController: UIViewController {

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
    }
}
