//  AudioPlayerManager.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import Foundation
import AVFoundation

@MainActor
final class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()
    private var player: AVAudioPlayer?

    func play(path: String) {
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("AVAudioPlayer error: \(error)")
        }
    }
}
