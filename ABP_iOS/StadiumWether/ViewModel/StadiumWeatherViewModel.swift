//
//  StadiumWeatherViewModel.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/4/23.
//

import Foundation
import Alamofire

class StadiumWeatherViewModel {
    
    @Published var weatherItems: [WeatherItem]!
    
    func requestWeatherAPI(latitude:Double,longitude:Double) {
        
        let grid = convertToWeatherGrid(latitude: latitude, longitude: longitude)
        let currentTime = getCurrentTimeForWeaterAPI()
        
        let baseUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let parameters =  [
            "serviceKey": Bundle.main.WEATER_API_KEY,
            "pageNo": "1",
            "numOfRows": "10",
            "dataType": "JSON",
            "base_date": currentTime.currentDate,
            "base_time": currentTime.currentHour,
            "nx": grid.x,
            "ny": grid.y ]
        
        AF.request(baseUrl, parameters: parameters)
            .validate(contentType:["application/json"])
            .responseDecodable(of:WeatherResponse.self) { response in
                switch response.result {
                case .success(let value) :
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 200..<300 :
                            print("Success - Status Code: \(statusCode)")
                            self.weatherItems = value.response.body.items.item
                            
                            print("Success - Response Value: \(self.weatherItems!)")
                            
                        case 400..<500:
                            // 클라이언트 오류 처리
                            print("Client Error - Status Code: \(statusCode)")
                            
                        case 500..<600:
                            // 서버 오류 처리
                            print("Server Error - Status Code: \(statusCode)")
                            
                        default:
                            // 그 외의 상태 코드 처리
                            print("Unknown Status Code: \(statusCode)")
                        }
                    }
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
    }
    
    
    func getCurrentTimeForWeaterAPI() -> (currentDate: String, currentHour: String) {
        var currentTime = Date()
        
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "yyyyMMdd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"  // 원하는 날짜 및 시간 형식 지정
        
        
        let currentHour = timeFormatter.string(from: currentTime)+"00"
        let currentDate = dateFormmatter.string(from: currentTime)
        
        
        return (currentDate ,currentHour)
    }
    
    
    func printGroupdata() {
        var groupedData: [String: [WeatherItem]] = [:]
        
        for item in self.weatherItems {
            let fcstTime = item.fcstTime
            if var existingGroup = groupedData[fcstTime] {
                existingGroup.append(item)
                groupedData[fcstTime] = existingGroup
            } else {
                groupedData[fcstTime] = [item]
            }
        }
        
        for (fcstTime, items) in groupedData {
            print("fcstTime: \(fcstTime)")
            for item in items {
                print("  \(item)")
            }
        }
    }
    
    
    func convertToWeatherGrid(latitude: Double, longitude: Double) -> (x: String, y: String) {
        // 기상청 격자 변환 상수
        let RE = 6371.00877
        let GRID = 5.0
        let SLAT1 = 30.0
        let SLAT2 = 60.0
        let OLON = 126.0
        let OLAT = 38.0
        let XO = 43
        let YO = 136
        
        let DEGRAD = Double.pi / 180.0
        
        let re = RE / GRID
        let slat1 = SLAT1 * DEGRAD
        let slat2 = SLAT2 * DEGRAD
        let olon = OLON * DEGRAD
        let olat = OLAT * DEGRAD
        
        var sn = tan(Double.pi * 0.25 + slat2 * 0.5) / tan(Double.pi * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        var sf = tan(Double.pi * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        var ro = tan(Double.pi * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
        
        var ra = tan(Double.pi * 0.25 + (latitude * DEGRAD) * 0.5)
        ra = re * sf / pow(ra, sn)
        var theta = longitude * DEGRAD - olon
        if theta > Double.pi {
            theta -= 2.0 * Double.pi
        }
        if theta < -Double.pi {
            theta += 2.0 * Double.pi
        }
        theta *= sn
        
        let x = String(Int(floor(ra * sin(theta) + Double(XO) + 0.5)))
        let y = String(Int(floor(ro - ra * cos(theta) + Double(YO) + 0.5)))
        
        return (x, y)
    }
}
