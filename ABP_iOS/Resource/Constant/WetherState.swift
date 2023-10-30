//
//  WetherState.swift
//  ABP_iOS
//
//  Created by 신진우 on 10/27/23.
//

import Foundation


//구름상태
enum Sky:String {
    case Sunny = "1"
    case Foggy = "3"
    case Cloudy = "4"
    
    
    var state: String {
        switch self {
        case .Sunny : return "맑음"
        case .Foggy : return "흐림"
        case .Cloudy : return "흐림"
        }
    }
}


//강수형태
enum Pty:String {
    case Sunny = "0"
    case Raniy = "1"
    case RainyAndSnowy = "2"
    case Snowy = "3"
    case Shower = "4"
    
    var state: String {
        switch self {
        case .Sunny : return "맑음"
        case .Raniy : return "비옴"
        case .RainyAndSnowy : return "눈 & 비"
        case .Snowy : return "눈"
        case .Shower : return "소나기"
        }
    }
}


