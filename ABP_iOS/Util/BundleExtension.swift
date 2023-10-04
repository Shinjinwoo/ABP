//
//  BundleExtension.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/30/23.
//

import Foundation


extension Bundle {
    var WEATER_API_KEY: String {
        guard let file = self.path(forResource: "API-KEY", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["WetherAPIKey"] as? String else {
            fatalError("WetherAPIKey Error")
        }
        
        return key
    }
}
