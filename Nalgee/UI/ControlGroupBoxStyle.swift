//
//  ControlGroupBoxStyle.swift
//  Nalgee
//
//  Created by Marcus Rossel on 18.06.21.
//

import SwiftUI

struct ControlGroupBoxStyle: GroupBoxStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.system(size: 18, design: .rounded).weight(.bold))
            
            configuration.content
                .font(.system(.callout, design: .rounded).weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

extension GroupBoxStyle where Self == ControlGroupBoxStyle {
    
    static var control: ControlGroupBoxStyle { ControlGroupBoxStyle() }
}

