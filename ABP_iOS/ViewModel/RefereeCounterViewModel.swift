//
//  RefereeCounterViewModel.swift
//  ABP_iOS
//
//  Created by 신진우 on 9/27/23.
//

import Foundation
import Combine


// 심판카운트기 VM,
class RefereeCounterViewModel:ObservableObject {
    
    
    private final let MAX_INNING:Int = 28
    private final let MAX_S: Int = 2;
    private final let MAX_B: Int = 3;
    private final let MAX_O: Int = 2;

    private var currentStage: Int = 2;
    private var currentLeftScore: Int = 0;
    private var currentRightScore: Int = 0;
    private var currentS: Int = 0;
    private var currentB: Int = 0;
    private var currentO: Int = 0;
    
    init(item:ScoreBoard) {
        print("RefereeCounterViewModel init")
        self.item = CurrentValueSubject(item)
    }
    
    let item: CurrentValueSubject<ScoreBoard,Never>
}
