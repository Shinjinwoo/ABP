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
    
    var currentTime:(currentDate:String,currentHour:String)!
    
    func requestWeatherAPI(latitude:Double,longitude:Double) {
        
        let grid = convertToWeatherGrid(latitude: latitude, longitude: longitude)
        self.currentTime = getCurrentTimeForWeaterAPI()
        
        let baseUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let parameters =  [
            "serviceKey": Bundle.main.WEATER_API_KEY,
            "pageNo": "1",
            "numOfRows": "100",
            "dataType": "JSON",
            "base_date": self.currentTime.currentDate,
            "base_time": self.currentTime.currentHour,
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
                            
                            //print("Success - Response Value: \(self.weatherItems!)")
                            
                            self.printGroupdata(targetBaseDate: self.currentTime.currentDate)
                            
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
        let currentTime = Date()
         
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "yyyyMMdd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"  // 원하는 날짜 및 시간 형식 지정
        
        
        let currentDate = dateFormmatter.string(from: currentTime)
        
        let calendar = Calendar.current

        // Base_time 값을 배열로
        let baseTimes = [
            calendar.date(bySettingHour: 2, minute: 0, second: 0, of: currentTime)!,
            calendar.date(bySettingHour: 5, minute: 0, second: 0, of: currentTime)!,
            calendar.date(bySettingHour: 8, minute: 0, second: 0, of: currentTime)!,
            calendar.date(bySettingHour: 11, minute: 0, second: 0, of: currentTime)!,
            calendar.date(bySettingHour: 14, minute: 0, second: 0, of: currentTime)!,
            calendar.date(bySettingHour: 17, minute: 0, second: 0, of: currentTime)!,
            calendar.date(bySettingHour: 20, minute: 0, second: 0, of: currentTime)!,
            calendar.date(bySettingHour: 23, minute: 0, second: 0, of: currentTime)!
        ]

        // 현재 시간과 가장 가까운 Base_time 값을 찾는로직
        var closestBaseTime = baseTimes[0]
        var timeDifference = abs(currentTime.timeIntervalSince(closestBaseTime))
        for baseTime in baseTimes {
            let difference = abs(currentTime.timeIntervalSince(baseTime))
            if difference < timeDifference {
                closestBaseTime = baseTime
                timeDifference = difference
            }
        }

        // 찾은 가장 가까운 Base_time 값을 출력하는 로직
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        let currentHour = dateFormatter.string(from: closestBaseTime)
        print("현재 시스템 시간: \(dateFormatter.string(from: currentTime))")
        print("가장 가까운 Base_time: \(currentHour)")
        
        return (currentDate ,currentHour)
    }
    
    
    func printGroupdata(targetBaseDate:String) {
        
        var weatherItemModels: [WeatherItemModel] = []

        // WeatherItem 배열을 순회하면서 그룹화
        var groupedData: [String: [String: String]] = [:]

        let filteredWeatherItems = weatherItems.filter { $0.baseDate == targetBaseDate }

        for item in weatherItems {
            let fcstTime = item.fcstTime
            let fcstDate = item.fcstDate
            
            print("Date:\(item.fcstDate) Time:\(fcstTime)")
            var group = groupedData[fcstTime] ?? [:]

            // category를 키로, fcstValue를 값으로 매핑
            group[item.category] = item.fcstValue

            // Dictionary 업데이트
            groupedData[fcstTime] = group
        }

        for (fcstTime, weatherData) in groupedData {
            let weatherItemModel = WeatherItemModel(fcstTime: fcstTime, weatherData: weatherData)
            weatherItemModels.append(weatherItemModel)
        }
        
        print(weatherItemModels)
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
