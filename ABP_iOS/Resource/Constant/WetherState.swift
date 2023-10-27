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
        case .Sunny : return "1"
        case .Foggy : return "3"
        case .Cloudy : return "4"
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
        case .Sunny : return "0"
        case .Raniy : return "1"
        case .RainyAndSnowy : return "2"
        case .Snowy : return "3"
        case .Shower : return "4"
        }
    }
}


