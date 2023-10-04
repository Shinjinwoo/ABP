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
                   encoding: ParameterEncoding = URLEncoding.default,
                   headers: HTTPHeaders? = nil ) -> AnyPublisher<Data, AFError> {
        
        return AF.request(url,method: method, parameters: parameters, encoding: URLEncoding.default,
                          headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            /** 서버로부터 받은 데이터 활용 */
            switch response.result {
            case .success(let data):
                /** 정상적으로 reponse를 받은 경우 */
                print(data)
            case .failure(let error): break
                /** 그렇지 않은 경우 */
            }
        }
        .publishData()
        .value()
    }
}
