//
//  SpotView.AudioView.Model.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI
import Combine

extension SpotView.AudioView {
        
    final class Model: ObservableObject {
        
        @Published var showControls = true
        @Published var color: Color = .white
        @Published var microphone = Microphone()
        
        var opacity: Double { Double(max(microphone.level - microphone.cutoffLevel, 0)) }
        
        var isEnabled: Bool { microphone.isEnabled }
        
        var isActive: Bool {
            @available(*, unavailable) get { fatalError("Unreachable") }
            set {
                microphone.isActive = newValue
            }
        }
        
        private var subscriptions: Set<AnyCancellable> = []
        
        var brightness: CGFloat {
            get {
                UIScreen.main.brightness
            } set {
                UIScreen.main.brightness = newValue
                objectWillChange.send()
            }
        }
        
        init() {
            microphone.objectWillChange
                .sink { [weak self] _ in self?.objectWillChange.send() }
                .store(in: &subscriptions)
            
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


