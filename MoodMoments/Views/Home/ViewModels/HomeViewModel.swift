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
import CoreAudio
import Speech

@MainActor
final class HomeViewModel: ObservableObject {
    private let context: ModelContext
    @Published var transcript: String = ""
    private var speechRecognizer: SpeechRecognizer? = nil
    init(context: ModelContext) {
        self.context = context
        self.speechRecognizer = SpeechRecognizer()
    }
    // Recording
    @Published var isRecording = false
    @Published var secondsElapsed = 0
    @Published var didFinishRecording = false

    private var timer: Timer?
    
    // Audio
    private var audioRecorder: AVAudioRecorder?

    private var transcriptUpdateTask: Task<Void, Never>? = nil

    func toggleRecording(time: Int) {
        if isRecording {
            stopRecording()
            speechRecognizer?.stopTranscribing()
            transcriptUpdateTask?.cancel()
            transcriptUpdateTask = nil
        } else {
            startRecording(time: time)
            transcript = ""
            speechRecognizer?.resetTranscript()
            speechRecognizer?.startTranscribing()
            transcriptUpdateTask = Task { [weak self] in
                while let self, self.isRecording {
                    if let latest = await self.speechRecognizer?.transcript {
                        await MainActor.run { self.transcript = latest }
                    }
                    try? await Task.sleep(nanoseconds: 300_000_000) // 0.3s
                }
            }
        }
    }

    private func startRecording(time: Int) {
        let maxSeconds: Int = time;
        let settings: [String: Any] = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                       AVSampleRateKey: 12000,
                                       AVNumberOfChannelsKey: 1,
                                       AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        let fileURL = Self.audioFileURL()
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
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
                    let size = try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int
                    print("File size after recording: \(size ?? -1)")
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
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
            print("AudioSession deactivate error: \(error)")
        }
        if let url = audioRecorder?.url {
            let size = try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int
            print("File size after stop: \(size ?? -1)")
        }
    }

    func saveMood(mood: Int, audioLenght: Int) {
        guard let url = audioRecorder?.url else { return }
        let currentDateTime = Date()
        let entry = MoodEntry(mood: mood, date: currentDateTime, audioFilePath: url.path, audioLenght: audioLenght, transcript: transcript)
        context.insert(entry)
        try? context.save()
        
        print(url.path)
    }

    // MARK: – Helpers

    // Hilfsfunktion für einen sicheren, persistenten Speicherort
}
