//  HomeViewModel.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 24.06.25.
//

import Foundation
import Combine
import AVFoundation
import SwiftData
import SwiftUICore

@MainActor
final class HomeViewModel: ObservableObject {
    private let context: ModelContext
    init(context: ModelContext) {
        self.context = context
    }
    // Recording
    @Published var isRecording = false
    @Published var secondsElapsed = 0
    @Published var didFinishRecording = false

    private var timer: Timer?
    
    // Audio
    private var audioRecorder: AVAudioRecorder?

    func toggleRecording(time: Int) {
        isRecording ? stopRecording() : startRecording(time: time)
    }

    private func startRecording(time: Int) {
        var maxSeconds: Int = time;
        let settings: [String: Any] = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                       AVSampleRateKey: 12000,
                                       AVNumberOfChannelsKey: 1,
                                       AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            secondsElapsed = 0
            didFinishRecording = false
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self else { return }
                self.secondsElapsed += 1
                if self.secondsElapsed >= maxSeconds {
                    self.stopRecording()
                }
            }
        } catch {
            print("Audio Recorder error: \(error)")
        }
    }

    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        timer?.invalidate()
        timer = nil
        didFinishRecording = true
    }

    func saveMood(mood: Int, audioLenght: Int) {
        guard let url = audioRecorder?.url else { return }
        print(url)
        print(mood)
        print(audioLenght)
        let entry = MoodEntry(mood: mood, audioFilePath: url.path, audioLenght: audioLenght)
        context.insert(entry)
        try? context.save()
    }

    // MARK: – Helpers
    func smiley(for mood: Int) -> String { MoodEntry(mood: mood).smiley }
    
    func smileyColor(for mood: Int) -> Color { MoodEntry(mood: mood).smileyColor }

    func smileyLabel(for mood: Int) -> String { MoodEntry(mood: mood).moodLabel }
}
