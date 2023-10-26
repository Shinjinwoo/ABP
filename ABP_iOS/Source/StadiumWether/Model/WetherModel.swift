//
//  WetherModel.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/4/23.
//

import Foundation


struct WeatherResponse: Codable {
    let response: Response

    struct Response: Codable {
        let header: Header
        let body: Body

        struct Header: Codable {
            let resultCode: String
            let resultMsg: String
        }

        struct Body: Codable {
            let dataType: String
            let items: Items
            let pageNo: Int
            let numOfRows: Int
            let totalCount: Int

            struct Items: Codable {
                let item: [WeatherItem]
            }
        }
    }
}

struct WeatherItem: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
}

struct Weather: Hashable,Codable {
    var fcstTime: String
    let fcstDate: String
    let weatherData: WeatherData
    //let fcstDate: String
    //let weatherData: [String: String] // category를 키로, fcstValue를 값으로 매핑한 데이터
    
    // 이니셜라이저
    init(fcstTime: String,fcstDate:String, weatherData: WeatherData) {
        //self.fcstDate = fcstDate
        self.fcstTime = fcstTime
        self.fcstDate = fcstDate
        self.weatherData = weatherData
    }
}

struct WeatherData: Hashable,Codable{
    let PCP: String // 강수량
    let SKY: String // 하늘 상태 코드
    let PTY: String // 강수 형태 코드
    let VEC: String // 풍향
    let WSD: String // 풍속
    let VVV: String // 수직 풍속
    let POP: String // 강수 확률
    let WAV: String // 파고
    let REH: String // 상대 습도
    let SNO: String // 적설량
    let UUU: String // 동서방향 풍속
    let TMP: String // 기온
}
