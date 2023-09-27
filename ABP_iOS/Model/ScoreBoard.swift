//
//  ScoreBoard.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/26/23.
//

import Foundation


struct ScoreBoard: Hashable {
    let strikeCount: Int
    let ballCount: Int
    let outCount: Int
    let inning: Int
}
