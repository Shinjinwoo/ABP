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
    
    init(item:ScoreBoard) {
        print("RefereeCounterViewModel init")
        self.item = CurrentValueSubject(item)
    }
    
    let item: CurrentValueSubject<ScoreBoard,Never>
    
}
