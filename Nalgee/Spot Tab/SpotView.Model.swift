//
//  SpotView.Model.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI
import Combine

extension SpotView {
 
    final class Model: ObservableObject {
        
        @Published var mode: Mode = .audio {
            didSet {
                switch mode {
                case .audio:
                    audioModel.isActive = true
                    pulseModel.isActive = false
                case .pulse:
                    pulseModel.isActive = true
                    audioModel.isActive = false
                }
            }
        }
        
        private var subscriptions: Set<AnyCancellable> = []
        
        private lazy var pulseModel: PulseView.Model = {
            let model = PulseView.Model()
            
            model.objectWillChange
                .sink { [weak self] newValue in self?.objectWillChange.send() }
                .store(in: &subscriptions)
            
            pulseModel = model
            return model
        }()
        
        private lazy var audioModel: AudioView.Model = {
            let model = AudioView.Model()
            
            model.objectWillChange
                .sink { [weak self] newValue in self?.objectWillChange.send() }
                .store(in: &subscriptions)
            
            audioModel = model
            return model
        }()
        
        @Published var showControls = true {
            didSet {
                switch mode {
                case .audio: audioModel.showControls = showControls
                case .pulse: pulseModel.showControls = showControls
                }
            }
        }
        
        var isActive: Bool {
            @available(*, unavailable) get { fatalError("Unreachable.") }
            set {
                switch mode {
                case .audio: audioModel.isActive = newValue
                case .pulse: pulseModel.isActive = newValue
                }
            }
        }
        
        var isEnabled: Bool {
            switch mode {
            case .audio: return audioModel.isEnabled
            case .pulse: return true
            }
        }
        
        @ViewBuilder var modeView: some View {
            switch mode {
            case .audio: SpotView.AudioView(model: audioModel)
            case .pulse: SpotView.PulseView(model: pulseModel)
            }
        }
    }
}
