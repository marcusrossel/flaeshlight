//
//  NoMicrophoneAccessView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI

struct NoMicrophoneAccessView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "mic.slash.fill")
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .foregroundColor(.red)
            
            Text("Audio control requires access to the microphone.")
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
            
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

struct NoMicrophoneAccessView_Previews: PreviewProvider {
    static var previews: some View {
        NoMicrophoneAccessView()
    }
}
