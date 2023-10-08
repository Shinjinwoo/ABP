//
//  AddressModel.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/8/23.
//

import Foundation

struct AddressModel: Codable {
    let roadAddress: String
    let jibunAddress: String
    let latitude: Double
    let longitude: Double
    
    init?(jsonData: [String:Any]) {
        guard
            let roadAddress = jsonData["roadAddress"] as? String,
            let jibunAddress = jsonData["jibunAddress"] as? String,
            let latitudeStr = jsonData["latitude"] as? String,
            let longitudeStr = jsonData["longitude"] as? String,
            let latitude = Double(latitudeStr),
            let longitude = Double(longitudeStr)
        else {
            return nil
        }

        self.roadAddress = roadAddress
        self.jibunAddress = jibunAddress
        self.latitude = latitude
        self.longitude = longitude
    }
}

