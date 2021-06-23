//
//  SpotView.PulseView.Model.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI
import Combine

extension SpotView.PulseView {
        
    final class Model: ObservableObject {
        
        @Published var showControls = true
        @Published var color: Color = .white
        
        @Published var opacityCycle: Measurement<UnitDuration> = .init(value: 0, unit: .seconds) {
            didSet {
                if opacityCycle.value.isZero {
                    timerHandle?.cancel()
                    timerHandle = nil
                    opacity = 1
                } else if timerHandle == nil {
                    subscribeToTimer()
                }
            }
        }
        
        private var cycleTimer = Timer.publish(every: 1.0 / 60, on: .main, in: .common)
        
        private func opacity(for elapsedTime: TimeInterval) -> Double {
            let normedElapsedTime = elapsedTime.truncatingRemainder(dividingBy: opacityCycle.value) / opacityCycle.value
            
            if normedElapsedTime < 0.5 {
                return 1 - (2 * normedElapsedTime)
            } else {
                return (2 * normedElapsedTime) - 1
            }
        }
        
        @Published var opacity: Double = 1
        
        @Published var isActive = true {
            didSet {
                if isActive {
                    if timerHandle == nil && !opacityCycle.value.isZero {
                        subscribeToTimer()
                    }
                } else {
                    timerHandle?.cancel()
                    timerHandle = nil
                }
            }
        }
        
        private var timerHandle: Cancellable?
        
        private func subscribeToTimer() {
            let start = Date()
            
            timerHandle = cycleTimer
                .autoconnect()
                .sink { [weak self, start] _ in
                    guard let self = self else { return }
                    let elapsedTime = start.distance(to: Date())
                    self.opacity = self.opacity(for: elapsedTime)
                }
        }
        
        var brightness: CGFloat {
            get {
                UIScreen.main.brightness
            } set {
                UIScreen.main.brightness = newValue
                objectWillChange.send()
            }
        }
        
        init() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(brightnessDidChange),
                name: UIScreen.brightnessDidChangeNotification,
                object: nil
            )
        }
        
        @objc private func brightnessDidChange() {
            objectWillChange.send()
        }
    }
}

