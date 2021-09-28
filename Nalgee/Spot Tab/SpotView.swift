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
            
            /*
            Menu picker style seems to be buggy, as it ignores the custom label.
            
            Picker(selection: $model.mode) {
                ForEach(Mode.allCases) { mode in
                    Label(mode.rawValue, systemImage: mode.symbol)
                }
            } label: {
                Image(systemName: model.mode.symbol).font(.system(size: 22, design: .rounded).weight(.bold))
            }
            .pickerStyle(.menu)
             
            This is a workaround:
            */
            
            Menu {
                ForEach(Mode.allCases) { mode in
                    Button(action: { model.mode = mode }) {
                        Label(mode.rawValue, systemImage: mode.symbol)
                    }
                }
            } label: {
                Image(systemName: model.mode.symbol).font(.system(size: 22, design: .rounded).weight(.bold))
            }

            
            
        }
        .padding([.top, .leading, .trailing])
    }
}
