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
        //let grid = convertToWeatherGrid(latitude: latitude, longitude: longitude)
        //self.currentTime = getCurrentTimeForWeaterAPI()
        
        //let baseUrl = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let parameters =  [
            "serviceKey": Bundle.main.WEATER_API_KEY,
            "pageNo": "1",
            "numOfRows": "120",
            "dataType": "JSON",
            "base_date": currentTime.currentDate,
            "base_time": "0000",//currentTime.currentHour,
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
    
    //        AF.request(baseUrl, parameters: parameters)
    //            .validate(contentType:["application/json"])
    //            .responseDecodable(of:WeatherResponse.self) { response in
    //                switch response.result {
    //                case .success(let value) :
    //                    if let statusCode = response.response?.statusCode {
    //                        switch statusCode {
    //                        case 200..<300 :
    //                            print("Success - Status Code: \(statusCode)")
    //
    //                            self.weatherItems = value.response.body.items.item
    //                            self.publishedWeatherInfo(targetBaseDate: self.currentTime.currentDate)
    //
    //                        case 400..<500:
    //                            // 클라이언트 오류 처리
    //                            print("Client Error - Status Code: \(statusCode)")
    //
    //                        case 500..<600:
    //                            // 서버 오류 처리
    //                            print("Server Error - Status Code: \(statusCode)")
    //
    //                        default:
    //                            // 그 외의 상태 코드 처리
    //                            print("Unknown Status Code: \(statusCode)")
    //                        }
    //                    }
    //                case .failure(let error):
    //                    print("요청 실패: \(error.localizedDescription)")
    //                    self.errorFlag = error
    //                }
    //            }
    //    }
    
    //    static func fetchSignUpUserData(snsType:String,nickname:String,character:Int) -> AnyPublisher<SignUpUserResult, AFError> {
    //        let headers: HTTPHeaders = [
    //            .authorization(bearerToken: Bundle.main.atoApiTokken!)
    //        ]
    //
    //        let parameters: [String: Any] = [
    //            "snsType": snsType,
    //            "nickname": nickname,
    //            "character": character
    //        ]
    //
    //        return AF.request(API.fetchUserSignUp.url,
    //                          method: .post,
    //                          parameters: parameters,
    //                          encoding:JSONEncoding.default,
    //                          headers: headers)
    //            .publishDecodable(type: SignUpUserResult.self)
    //            .value()
    //            .eraseToAnyPublisher()
    //    }
    //
    //}
}
