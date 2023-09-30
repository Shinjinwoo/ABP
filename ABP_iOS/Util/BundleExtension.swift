//
//  BundleExtension.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/30/23.
//

import Foundation


extension Bundle {
    
    
    var NAVER_MAP_KEY: String {
        guard let file = self.path(forResource: "APIKey", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        guard let key = resource["NMFClientId"] as? String else {
            fatalError("NAVER_MAP_API_KEY Error")
        }
        
        return key
    }
}
