//
//  APIService.swift
//  AtoStudy_ShinJinwoo
//
//  Created by 신진우 on 10/24/23.
//

import Foundation
import Combine
import Alamofire

enum API {
    case fetchWeatherAPI // 회원가입 요청
    //case fetchChaters
    
    var url : URL {
        switch self {
        case .fetchWeatherAPI: return URL(string: "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst")!
        }
    }
}

enum APIService {
    
    static func fetchShortTiemWeatherStateAPI(grid:(x: String, y: String), currentTime: ( currentDate:String, currentHour:String)) ->AnyPublisher<WeatherInfo,AFError>{
        
        
        print(currentTime.currentHour)
        let parameters =  [
            "serviceKey": Bundle.main.WEATER_API_KEY,
            "pageNo": "1",
            "numOfRows": "120",
            "dataType": "JSON",
            "base_date": currentTime.currentDate,
            "base_time": currentTime.currentHour,
            "nx": grid.x,
            "ny": grid.y ]
        
        return AF.request(API.fetchWeatherAPI.url,
                          method: .get,
                          parameters: parameters,
                          encoding:URLEncoding.default )
        .publishDecodable(type: WeatherInfo.self)
        .value()
        .eraseToAnyPublisher()
    }
}
