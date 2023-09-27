//
//  ScoreBoard.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/26/23.
//

import Foundation

struct ScoreBoard: Hashable {
    var strikeCount: Int = 0
    var ballCount: Int = 0
    var outCount: Int = 0
    var inning: Int = 0
}
