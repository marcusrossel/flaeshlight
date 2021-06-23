//
//  TorchView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 17.06.21.
//

import SwiftUI

struct TorchView: View {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 0) {
            if model.showControls { title }
            
            if model.isEnabled {
                if model.showControls {
                    VStack(spacing: 12) {
                        LevelView(level: $model.microphone.level, cutoffLevel: $model.microphone.cutoffLevel)
                        controls
                    }
                    .padding()
                }
            } else {
                Spacer()
                disabledLabel
                Spacer()
            }
        }
    }
    
    @ViewBuilder private var title: some View {
        HStack {
            Text("Torch")
                .font(.system(size: 32, design: .rounded).weight(.heavy))
            Spacer()
        }
        .padding([.top, .leading, .trailing])
    }
    
    @ViewBuilder private var controls: some View {
        PercentageControlBox(
            title: "Brightness",
            systemImage: "flashlight.\(model.torch.brightness.isZero ? "off" : "on").fill",
            value: $model.torch.brightness
        )
        
        PercentageControlBox(title: "Sensitivity", systemImage: "waveform",               value: $model.microphone.sensitivity)
        PercentageControlBox(title: "Cutoff",      systemImage: "circle.bottomhalf.fill", value: $model.microphone.cutoffLevel)
    }
    
    @ViewBuilder private var disabledLabel: some View {
        if model.torch.isEnabled {
            NoMicrophoneAccessView()
        } else {
            NoFlashlightView()
        }
    }
}
