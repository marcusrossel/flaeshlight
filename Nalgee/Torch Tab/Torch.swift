//
//  Torch.swift
//  Nalgee
//
//  Created by Marcus Rossel on 17.06.21.
//

import SwiftUI
import Combine
import AVFoundation

final class Torch: ObservableObject {
    
    private let device: AVCaptureDevice?
    
    var level: Float = 0 {
        didSet {
            setTorch(to: level)
        }
    }
    
    @Published var brightness: Float = 1
    
    @Published private(set) var isEnabled: Bool
    
    @Published var isActive = true {
        willSet {
            if newValue == false { setTorch(to: 0) }
        }
    }
    
    private func setTorch(to level: Float) {
        guard isActive, let device = device else { return }
        
        do {
            try device.lockForConfiguration()
            
            let clampedBrightness = max(min(brightness, 1), 0)
            let adjustedLevel = level * clampedBrightness
            
            // https://medium.com/@hajimenakamura/the-passed-torchlevel-0-000000-is-invalid-b98499b11d5a
            if adjustedLevel.isZero {
                if device.isTorchModeSupported(.off) { device.torchMode = .off }
            } else {
                let clampedLevel = min(adjustedLevel, 1)
                try device.setTorchModeOn(level: clampedLevel)
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be set.")
        }
    }

    init() {
        let device = AVCaptureDevice.default(for: .video)
        self.device = device
        
        isEnabled = (device != nil) && (device?.hasTorch == true)
    }
}
