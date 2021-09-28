//
//  PercentageControlBox.swift
//  Nalgee
//
//  Created by Marcus Rossel on 18.06.21.
//

import SwiftUI

struct PercentageControlBox<Value: BinaryFloatingPoint>: View where Value.Stride: BinaryFloatingPoint {
    
    let title: String
    let systemImage: String
    @Binding var value: Value
    
    var body: some View {
        GroupBox(label: Label(title, systemImage: systemImage)) {
            HStack {
                let percentage = Int(100 * value)
                
                HStack {
                    Text("\(percentage)%")
                    Spacer(minLength: 0)
                }
                .frame(width: 50)

                Slider(value: $value, in: 0...1)
            }
        }
        .groupBoxStyle(.control)
    }    
}
