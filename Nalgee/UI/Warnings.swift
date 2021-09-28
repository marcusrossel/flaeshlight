//
//  Warnings.swift
//  Nalgee
//
//  Created by Marcus Rossel on 25.06.21.
//

import SwiftUI

// MARK: - No Flashlight

struct NoFlashlightView: View {
    
    var body: some View {
        BigLabel(
            systemImage: "bolt.slash.circle.fill",
            color: .red,
            text: "Your device does not have a flashlight."
        )
        .padding(32)
    }
}

// MARK: - No Microphone Access

struct NoMicrophoneAccessView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            BigLabel(
                systemImage: "mic.slash.fill",
                color: .red,
                text: "Audio control requires access to the microphone."
            )
            
            Spacer()
            
            Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                Label("Settings", systemImage: "gear")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(32)
    }
}
