//
//  TorchView.Model.swift
//  Nalgee
//
//  Created by Marcus Rossel on 17.06.21.
//

import SwiftUI
import Combine

extension TorchView {

    final class Model: ObservableObject {
        
        var torch = Torch()
        var microphone = Microphone()
        
        var isEnabled: Bool {
            #if targetEnvironment(simulator)
            true
            #else
            torch.isEnabled && microphone.isEnabled
            #endif
        }
        
        var isActive: Bool {
            @available(*, unavailable) get { fatalError("Unreachable") }
            set {
                torch.isActive = newValue
                microphone.isActive = newValue
            }
        }
        
        @Published var showControls = true {
            didSet {
                if showControls {
                    UIScreen.main.brightness = lastScreenBrightness
                } else {
                    lastScreenBrightness = UIScreen.main.brightness
                    UIScreen.main.brightness = 0
                }
            }
        }
                
        private var lastScreenBrightness: CGFloat = 0
        
        private var subscriptions: Set<AnyCancellable> = []
            
        init() {
            microphone.$level
                .sink { level in self.torch.level = max(level - self.microphone.cutoffLevel, 0) }
                .store(in: &subscriptions)
            
            microphone.$cutoffLevel
                .sink { cutoff in self.torch.level = max(self.microphone.level - cutoff, 0) }
                .store(in: &subscriptions)
            
            // https://stackoverflow.com/a/58406402/3208492
            
            torch.objectWillChange
                .sink { [weak self] _ in self?.objectWillChange.send() }
                .store(in: &subscriptions)
            
            microphone.objectWillChange
                .sink { [weak self] newValue in self?.objectWillChange.send() }
                .store(in: &subscriptions)
        }
    }
}
