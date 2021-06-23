//
//  SpotView.PulseView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI

extension SpotView {
    
    struct PulseView: View {
        
        @ObservedObject var model: Model
        
        var body: some View {
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
                
                if model.showControls { controls }
            }
        }

        @ViewBuilder private var controls: some View {
            VStack(spacing: 12) {
                PercentageControlBox(title: "Brightness", systemImage: "sun.max.fill", value: $model.brightness)
                
                GroupBox(label: Label("Cycle", systemImage: "clock.arrow.2.circlepath")) {
                    HStack {
                        let cycle = model.opacityCycle
                        
                        HStack {
                            Text(cycle.value.isZero ? "Off" : (String(format: "%.1f", cycle.value) + "s"))
                            Spacer(minLength: 0)
                        }
                        .frame(width: 50)
                        
                        Slider(value: $model.opacityCycle.value, in: 0...20)
                    }
                }
                .groupBoxStyle(ControlGroupBoxStyle())
            }
            .padding()
        }
    }
}
