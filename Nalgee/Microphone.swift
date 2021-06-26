//
//  Microphone.swift
//  Nalgee
//
//  Created by Marcus Rossel on 17.06.21.
//

import SwiftUI
import Combine
import AVFoundation

// https://medium.com/swlh/swiftui-create-a-sound-visualizer-cadee0b6ad37
final class Microphone: ObservableObject {
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    
    @Published private(set) var isEnabled = false
    
    @Published var level: Float = 0
    @Published var sensitivity: Float = 0.5
    @Published var cutoffLevel: Float = 0
    
    func reset() {
        minDB = 0
        maxDB = -.infinity
        isEnabled = AVAudioSession.sharedInstance().recordPermission == .granted
    }
    
    @Published var isActive = false {
        willSet {
            switch newValue {
            case true:
                if audioRecorder == nil { initialize() }
                reset()
                startMonitoring()
            case false:
                level = 0
                stopMonitoring()
            }
        }
    }
    
    // Converts the percentage-based `sensitivity` to an offset value for the level.
    private var levelOffset: Float { sensitivity * 2 - 1 }
    
    /* Quiet Level Detection:
     
    private var quietSamples: [Float] = []
    @Published private(set) var isDetectingQuietLevel = false
    
    func startDetectingQuietLevel(overridingOngoingSession overrideOngoingSession: Bool = true) {
        if isDetectingQuietLevel && !overrideOngoingSession { return }
        
        quietSamples.removeAll()
        isDetectingQuietLevel = true
    }
    
    func stopDetectingQuietLevel()  {
        isDetectingQuietLevel = false
        minDB = quietSamples.reduce(0, +) / Float(quietSamples.count)
    }
    */
    
    // Since the minimum possible dB value is -∞, we need to start at 0 (which is the maximum value).
    private var minDB: Float = 0
    // Since the maximum possible dB value is 0, we need to start at -∞ (which is the minimum value).
    private var maxDB: Float = -.infinity
    
    private func updateLevel(dB: Float) {
        minDB = min(dB, minDB)
        maxDB = max(dB, maxDB)
        
        // Since the maximum possible dB value is 0, dB values are always negative.
        // To make ratio-calculations easier, we therefore first normalize dB values into positive values:
        // We declare `minDB` to be 0 and shift the `dB` and `maxDB` accordingly.
        let normalizedDB = dB - minDB
        let normalizedMaxDB = maxDB - minDB
        let newLevel = (normalizedDB / normalizedMaxDB) + levelOffset
        
        guard newLevel.isFinite && !newLevel.isNaN else { return }
        level = newLevel
    }
    
    private func startMonitoring() {
        guard let recorder = audioRecorder else { return }
        
        recorder.isMeteringEnabled = true
        recorder.record()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            recorder.updateMeters()
            let dB = recorder.averagePower(forChannel: 0)
            
            self.updateLevel(dB: dB)
            
            /* if self.isDetectingQuietLevel { self.quietSamples.append(dB) } */
        }
    }
    
    private func stopMonitoring() {
        timer?.invalidate()
        audioRecorder?.stop()
    }
    
    private func initialize() {
        let audioSession = AVAudioSession.sharedInstance()

        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { [unowned self] isGranted in
                DispatchQueue.main.async { self.isEnabled = isGranted }
            }
        }
        
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        
        let recorderSettings: [String: Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default)
            startMonitoring()
        } catch {
            self.isEnabled = false
        }
    }
    
    deinit { stopMonitoring() }
}
