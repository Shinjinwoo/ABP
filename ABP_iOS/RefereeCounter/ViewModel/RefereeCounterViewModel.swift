//
//  RefereeCounterViewModel.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/27/23.
//

import Foundation
import Combine


// 심판카운트기 VM,
final class RefereeCounterViewModel {
    
    private final let MAX_INNING:Int = 28
    private final let MAX_STRIKECOUNT:Int = 2
    private final let MAX_BALLCOUNT:Int = 3
    private final let MAX_OUTCOUNT:Int = 2
    
    @Published var scoreboard: ScoreBoard
    
    init(scoreboard:ScoreBoard) {
        print("RefereeCounterViewModel init")
        self.scoreboard = scoreboard
    }
    
    func setStrikeCount(strikeCount:Int) {
        scoreboard.strikeCount = strikeCount
    }
    
    func setBallCount(ballCount:Int) {
        scoreboard.ballCount = ballCount
    }
    
    func setOutCount(outCount:Int) {
        scoreboard.outCount = outCount
    }
    
    func setInning(inning:Int) {
        scoreboard.inning = inning
    }
    
    func setHomeTeamScore(score:Int){
        scoreboard.homeTeamScore = score
    }
    func setAwayTeamScore(score:Int){
        scoreboard.awayTeamScore = score
    }
    
    func strikeOut() {
        
        if MAX_OUTCOUNT <= scoreboard.outCount {
            endOfTheInning()
            return
        }
        
        scoreboard.strikeCount = 0
        scoreboard.ballCount = 0
        scoreboard.outCount = scoreboard.outCount + 1
        
        print("strike out !")
    }
    
    func baseOnBalls() {
        scoreboard.strikeCount = 0
        scoreboard.ballCount = 0
        
        print("baseOnBalls")
    }
    
    func endOfTheInning() {
        scoreboard.strikeCount = 0
        scoreboard.ballCount = 0
        scoreboard.outCount = 0
        scoreboard.inning = scoreboard.inning + 1
    }
    
    func resetSBCount() {
        scoreboard.strikeCount = 0
        scoreboard.ballCount = 0
    }
    
    
    func resetScoreBoard() {
        scoreboard.strikeCount = 0
        scoreboard.ballCount = 0
        scoreboard.outCount = 0
        scoreboard.inning = 2
        scoreboard.homeTeamScore = 0
        scoreboard.awayTeamScore = 0
    }
    
}
