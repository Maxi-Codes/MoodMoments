//  AudioPlayerManager.swift
//  MoodMoments
//
//  Created by AI on 24.06.25.
//

import Foundation
import AVFoundation

@MainActor
final class AudioPlayerManager: NSObject, ObservableObject {
    static let shared = AudioPlayerManager()
    private var player: AVAudioPlayer?

    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 1
    private var progressTimer: Timer?
    @Published var currentFilePath: String? = nil

    func play(path: String) {
        let url = URL(fileURLWithPath: path)
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
            duration = player?.duration ?? 1
            startProgressTimer()
            currentFilePath = path
        } catch {
            print("AVAudioPlayer error: \(error)")
            isPlaying = false
            currentFilePath = nil
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
        stopProgressTimer()
        // currentFilePath bleibt gesetzt
    }

    func stop() {
        player?.stop()
        isPlaying = false
        stopProgressTimer()
        currentTime = 0
        currentFilePath = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("AudioSession deactivate error: \(error)")
        }
    }

    func fileExists(path: String?) -> Bool {
        guard let path else { return false }
        return FileManager.default.fileExists(atPath: path)
    }

    private func startProgressTimer() {
        stopProgressTimer()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self, let player = self.player else { return }
            self.currentTime = player.currentTime
            if !player.isPlaying {
                self.isPlaying = false
                self.stopProgressTimer()
            }
        }
    }

    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
}

// AVAudioPlayerDelegate für Session-Deaktivierung
extension AudioPlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            isPlaying = false
            stopProgressTimer()
            currentTime = 0
            currentFilePath = nil
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch {
                print("AudioSession deactivate error: \(error)")
            }
        }
    }
}
