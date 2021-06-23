//
//  SpotView.Mode.swift
//  Nalgee
//
//  Created by Marcus Rossel on 20.06.21.
//

import SwiftUI

extension SpotView {
    
    enum Mode: String, Identifiable, CaseIterable {
    
        case audio = "Live Audio"
        case pulse = "Pulse"
        
        var symbol: String {
            switch self {
            case .audio: return "waveform"
            case .pulse: return "clock.arrow.2.circlepath"
            }
        }
        
        var id: Self { self }
    }
}
