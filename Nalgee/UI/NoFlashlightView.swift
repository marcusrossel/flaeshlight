//
//  NoFlashlightView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI

struct NoFlashlightView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bolt.slash.circle.fill")
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .foregroundColor(.red)
            
            Text("Your device does not have a flashlight.")
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }
}
