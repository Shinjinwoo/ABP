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
