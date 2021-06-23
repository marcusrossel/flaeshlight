//
//  SpotView.AudioView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI

extension SpotView {
    
    struct AudioView: View {
        
        @ObservedObject var model: Model
        
        var body: some View {
            if model.isEnabled {
                VStack {
                    Circle()
                        .foregroundColor(model.color.opacity(model.opacity))
                        .frame(width: Screen.points(for: SpotView.nalgeneDiameter).map(CGFloat.init(_:)))
                        .frame(width: UIScreen.main.bounds.width)
                        .clipShape(Rectangle())
                        .overlay(
                            ColorPicker("Color", selection: $model.color, supportsOpacity: false)
                                .labelsHidden()
                                .opacity(model.showControls ? 1 : 0)
                        )
                    
                    if model.showControls {
                        VStack(spacing: 12) {
                            LevelView(
                                level: $model.microphone.level,
                                cutoffLevel: $model.microphone.cutoffLevel,
                                orientation: .horizontal
                            )
                            .frame(height: 20)
                            
                            controls
                        }
                        .padding()
                    }
                }
            } else {
                Spacer()
                NoMicrophoneAccessView()
                Spacer()
            }
        }

        @ViewBuilder private var controls: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    PercentageControlBox(title: "Brightness", systemImage: "sun.max.fill", value: $model.brightness)
                    PercentageControlBox(title: "Sensitivity", systemImage: "waveform", value: $model.microphone.sensitivity)
                    PercentageControlBox(title: "Cutoff", systemImage: "circle.bottomhalf.fill", value: $model.microphone.cutoffLevel)
                }
            }
        }
    }
}
