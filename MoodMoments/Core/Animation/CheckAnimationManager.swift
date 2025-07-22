//
//  CheckAnimationManager.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 22.07.25.
//

import SwiftUI
import Combine

class CheckAnimationManager: ObservableObject {
    static let shared = CheckAnimationManager()
    
    @Published var message: String = ""
    @Published var show: Bool = false

    func showCheckAnimation(_ message: String) {
        self.message = message
        withAnimation {
            self.show = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                self.show = false
            }
        }
    }
}
