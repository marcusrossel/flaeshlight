//
//  SpotView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 18.06.21.
//

import SwiftUI

struct SpotView: View {
    
    static let nalgeneDiameter: Measurement<UnitLength> = .init(value: 7, unit: .centimeters)
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack {
            if model.showControls { titleBar }
            
            model.modeView
        }
    }
    
    @ViewBuilder private var titleBar: some View {
        HStack(spacing: 12) {
            Text("Spot")
                .font(.system(size: 32, design: .rounded).weight(.heavy))
            
            Spacer()
            
            Picker(
                selection: $model.mode,
                label: Image(systemName: model.mode.symbol).font(.system(size: 22, design: .rounded).weight(.bold))
            ) {
                ForEach(Mode.allCases) { mode in
                    Label(mode.rawValue, systemImage: mode.symbol)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding([.top, .leading, .trailing])
    }
}
