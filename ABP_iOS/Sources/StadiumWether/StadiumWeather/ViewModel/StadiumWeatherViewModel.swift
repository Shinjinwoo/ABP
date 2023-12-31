//
//  StadiumWeatherViewModel.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/4/23.
//

import Foundation
import Alamofire
import Combine

class StadiumWeatherViewModel {
    
    
    
    @Published var items: [Weather]!
    @Published var selectedItem: Weather!
    @Published var errorFlag: Error!
    @Published var statusMsg: Header!
    
    var mCurrentTime: (currentDate:String,currentHour:String)!
    var weatherItems: [WeatherItem]!
    var retrycount: Int = 0
    
    
    private var subcriptions = Set<AnyCancellable>()
    
    func fetchWeatherAPI(latitude:Double,longitude:Double,nextTime:String? = nil) {
                
        if nextTime == nil {
            mCurrentTime = getCurrentTimeForWeaterAPI()
        } else {
            mCurrentTime.currentHour = self.subtractOneHourAndConvertToMidnightFormat(timeStr: self.mCurrentTime.currentHour)!
        }

        
        APIService.fetchShortTiemWeatherStateAPI(
            grid: convertToWeatherGrid(latitude: latitude, longitude: longitude),
            currentTime: mCurrentTime)
        .sink {
            completion in
            switch completion {
            case .failure(let err):
                print("ViewModel - fetchShortTiemWeatherStateAPI: err: \(err)")
                //self.apiError = err
            case .finished:
                print("ViewModel - fetchShortTiemWeatherStateAPI: finished")
                
            }
        }  receiveValue: { value in
            if value.response.header.resultMsg == "NO_DATA" {
                if self.shouldRetryAPI() {
                    self.fetchWeatherAPI(latitude: latitude, longitude: longitude, nextTime: self.mCurrentTime.currentHour)
                } else {
                    self.statusMsg = value.response.header
                }
            } else {
                if value.response.body != nil {
                    self.items = self.publishedWeatherInfo(targetBaseDate: self.mCurrentTime.currentDate,weatherItems: value.response.body!.items.item)
                } else {
                    print(value)
                }
            }
            
            
            
        }.store(in: &subcriptions)
    }
    
    func shouldRetryAPI() -> Bool {
        if retrycount <= 10 {
            retrycount += 1
            return true
        }
        return false // 재호출하지 않을 경우
    }
    
    
    func didSelect(at indexPath: IndexPath) {
        let item = items[indexPath.item]
        selectedItem = item
        
        print(selectedItem!)
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
    
    
    func subtractOneHourAndConvertToMidnightFormat(timeStr: String) -> String? {
        if timeStr == "2400" {
            return "0000"
        } else if let timeInt = Int(timeStr) {
            // 시간과 분 추출
            let hour = timeInt / 100
            let minute = timeInt % 100
            
            // 1시간 빼기
            var newHour = hour - 1
            
            // 시간이 음수가 되면 23으로 설정
            if newHour < 0 {
                newHour = 23
            }
            
            // 시간과 분을 다시 문자열로 변환
            let result = String(format: "%02d%02d", newHour, minute)
            
            return result
        } else {
            return nil
        }
    }
    
    
    func publishedWeatherInfo(targetBaseDate:String,weatherItems : [WeatherItem]) -> [Weather] {
        
        var weatherItemModels: [Weather] = []
        
        // WeatherItem 배열을 순회하면서 그룹화
        var groupedData: [String: [String: String]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let startDateString:String? = weatherItems[0].baseDate
        guard let startDate = dateFormatter.date(from: startDateString!) else {
            fatalError("Invalid start date format")
        }
        
        // 시작 날짜 설정
        
        var endDateString:String?
        // 시작 날짜에 1일을 더한 날짜가 종료 날짜가 된다.
        if let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) {
            endDateString = dateFormatter.string(from: endDate)
        } else {
            fatalError("Failed to calculate endDate")
            endDateString = startDateString
        }
        
        let filteredWeatherItems = weatherItems.filter { item in
            // fcstDate를 문자열에서 날짜로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            
            if let itemDate = dateFormatter.date(from: item.fcstDate), // 옵셔널 바인딩 제거
               let startDateString = startDateString,
               let endDateString = endDateString {
                
                if let startDate = dateFormatter.date(from: startDateString),
                   let endDate = dateFormatter.date(from: endDateString) {
                    
                    // 시작일 이후이고 종료일 이전인 항목 선택
                    return itemDate >= startDate && itemDate <= endDate
                }
            }
            return false
        }
        
        for item in filteredWeatherItems {
            let fcstTime = item.fcstTime
            let fcstDate = item.fcstDate
            
            var group = groupedData[fcstTime] ?? [:]
            
            // category를 키로, fcstValue를 값으로 매핑
            group[item.category] = item.fcstValue
            
            group["fcstDate"] = fcstDate
            
            // Dictionary 업데이트
            groupedData[fcstTime] = group
        }
        
        
        for (fcstTime, weatherData) in groupedData {
            
            let fcstDate = weatherData["fcstDate"] ?? "Unknown"
            
            let weatherData = WeatherData(PCP: weatherData["PCP"] ?? "",
                                          SKY: weatherData["SKY"] ?? "",
                                          PTY: weatherData["PTY"] ?? "",
                                          VEC: weatherData["VEC"] ?? "",
                                          WSD: weatherData["WSD"] ?? "",
                                          VVV: weatherData["VVV"] ?? "",
                                          POP: weatherData["POP"] ?? "",
                                          WAV: weatherData["WAV"] ?? "",
                                          REH: weatherData["REH"] ?? "",
                                          SNO: weatherData["SNO"] ?? "",
                                          UUU: weatherData["UUU"] ?? "",
                                          TMP: weatherData["TMP"] ?? "")
            
            let weatherItemModel = Weather(fcstTime: fcstTime,fcstDate:fcstDate, weatherData: weatherData)
            weatherItemModels.append(weatherItemModel)
        }
        
        //최종적으로 날짜가 더 빠르고, 시간이 base타임과 가장 비슷한 시각부터 정렬된다
        weatherItemModels = weatherItemModels.sorted { (weather1, weather2) -> Bool in
            if weather1.fcstDate != weather2.fcstDate {
                return weather1.fcstDate < weather2.fcstDate
            } else {
                return weather1.fcstTime < weather2.fcstTime
            }
        }
        
        for index in 0..<weatherItemModels.count {
            weatherItemModels[index].fcstTime = convertToTimeForKor(formatHHmmTime: weatherItemModels[index].fcstTime) // 새로운 fcstTime 값으로 변경
        }
        
        //퍼블리싱
        return weatherItemModels
    }
    
    
    func convertToTimeForKor(formatHHmmTime:String) ->String {
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
