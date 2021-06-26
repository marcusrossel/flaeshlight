//
//  BigLabel.swift
//  Nalgee
//
//  Created by Marcus Rossel on 25.06.21.
//

import SwiftUI

struct BigLabel: View {
    
    let systemImage: String
    let color: Color
    let text: LocalizedStringKey
    var textSize: CGFloat = 24
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .foregroundColor(color)
            
            Text(text)
                .font(.system(size: textSize, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
        }
    }
}

struct BigLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        BigLabel(
            systemImage: "bolt.slash.circle.fill",
            color: .red,
            text: "Your device does not have a flashlight."
        )
    }
}
