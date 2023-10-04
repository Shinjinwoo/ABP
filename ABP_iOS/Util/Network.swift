//
//  Network.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/4/23.
//

import Foundation
import Alamofire
import Combine



final class Network {
    func fetchData(url: String,
                   method: HTTPMethod = .get,
                   parameters: Parameters? = nil,
                   encoding: ParameterEncoding = URLEncoding.default ) -> AnyPublisher<Data, AFError> {
        
        return AF.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: URLEncoding.default )
        //.publishDecodable(type:WeatherResponse.self)
        .publishData()
        .value()
        .eraseToAnyPublisher()
    }
}
