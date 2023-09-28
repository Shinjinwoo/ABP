//
//  ScoreBoard.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/26/23.
//

import Foundation

struct ScoreBoard: Hashable {
    var strikeCount: Int
    var ballCount: Int
    var outCount: Int
    var inning: Int
    var homeTeamScore: Int
    var awayTeamScore: Int
}

extension ScoreBoard {
    static let `default` = ScoreBoard(strikeCount: 0, ballCount: 0, outCount: 0, inning: 2,homeTeamScore: 0,awayTeamScore: 0)
}
