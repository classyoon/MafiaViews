//
//  DiscussionViewModel.swift
//  MafiaViews
//
//  Created by Conner Yoon on 5/3/25.
//

import Foundation
class DiscussionViewModel: ObservableObject {
    private let gameManager = GameManager.shared
    
    @Published var timeRemaining: Int = 60
    @Published var canSkipDiscussion = false
    @Published var continueToVoting = false
    
    private var timer: Timer?
    
    init(discussionTime: Int = 60) {
        self.timeRemaining = discussionTime
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                // Allow skipping after half the time has passed
                if self.timeRemaining <= 30 {
                    self.canSkipDiscussion = true
                }
            } else {
                self.timer?.invalidate()
                self.continueToVoting = true
            }
        }
    }
    
    func skipDiscussion() {
        if canSkipDiscussion {
            timer?.invalidate()
            continueToVoting = true
        }
    }
}

