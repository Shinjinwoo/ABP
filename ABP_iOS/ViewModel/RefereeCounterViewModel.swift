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
    private final let MAX_S: Int = 2;
    private final let MAX_B: Int = 3;
    private final let MAX_O: Int = 2;
    
    @Published var scoreboard: ScoreBoard
    
    init(scoreboard:ScoreBoard) {
        print("RefereeCounterViewModel init")
        self.scoreboard = scoreboard
    }
    
    
    private func strikePlus() {
        
        
    }
    
    
}
