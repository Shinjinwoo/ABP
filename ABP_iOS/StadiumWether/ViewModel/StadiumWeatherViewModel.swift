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
        
        let baseUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let parameters =  [
            "serviceKey": Bundle.main.WEATER_API_KEY,
            "pageNo": "1",
            "numOfRows": "10",
            "dataType": "JSON",
            "base_date": "20231004",
            "base_time": "0500",
            "nx": grid.x,
            "ny": grid.y ]
        
        AF.request(baseUrl, parameters: parameters)
            .validate(statusCode: 200..<300)
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
                            self.printGroupdata()
                            
                        default:
                            print("Unknown Status Code: \(statusCode)")
                        }
                    }
                case .failure(let error):
                    print("요청 실패: \(error)")
                }
            }
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
    
    
//    {
//        .responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let statusCode = response.response?.statusCode {
//                    switch statusCode {
//                    case 200..<300:
//                        // 성공적인 응답 처리
//                        print("Success - Status Code: \(statusCode)")
//                        // JSON 응답 처리
//                        print("Response JSON: \(value)")
//                        
//                        if let jsonData = try? JSONSerialization.data(withJSONObject: value) {
//                            do {
//                                let decoder = JSONDecoder()
//                                let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
//                                self.weatherItems = weatherResponse.response.body.items
//                                // weatherResponse를 사용하여 데이터를 처리합니다.
//                                print(self.weatherItems!)
//                            } catch {
//                                print("JSON 디코딩 오류: \(error)")
//                            }
//                        }
//                    case 400..<500:
//                        // 클라이언트 오류 처리
//                        print("Client Error - Status Code: \(statusCode)")
//                        
//                    case 500..<600:
//                        // 서버 오류 처리
//                        print("Server Error - Status Code: \(statusCode)")
//                        
//                    default:
//                        // 그 외의 상태 코드 처리
//                        print("Unknown Status Code: \(statusCode)")
//                    }
//                }
//                
//            case .failure(let error):
//                print("요청 실패: \(error)")
//            }
//        }
//    }
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
