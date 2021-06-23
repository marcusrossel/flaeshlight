//
//  LevelView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 17.06.21.
//

import SwiftUI

struct LevelView: View {
    
    @Binding var level: Float
    @Binding var cutoffLevel: Float
    
    var orientation: Orientation = .vertical
    var segmentCount = 15
    
    private func color(for segement: Int) -> Color {
        // The greatest height identifies the top most segement.
        let height = (1 - Float(segement) / Float(segmentCount - 1))
        
        // Segments above the loudness line get the background color.
        guard height <= level else { return Color(.systemBackground) }
        
        switch height {
        case _ where cutoffLevel == 1: fallthrough
        case ..<cutoffLevel:           return Color(.tertiarySystemFill)
        case 0..<0.6:                  return .green
        case (0.6)..<0.8:              return .yellow
        default:                       return .red
        }
    }
    
    @ViewBuilder private var cells: some View {
        let segments: [Int] = {
            switch orientation {
            case .vertical:   return Array(0..<segmentCount)
            case .horizontal: return (0..<segmentCount).reversed()
            }
        }()
        
        ForEach(segments, id: \.self) { segment in
            RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                .foregroundColor(color(for: segment))
        }
    }
    
    var body: some View {
        switch orientation {
        case .vertical:   VStack(spacing: 4) { cells }
        case .horizontal: HStack(spacing: 4) { cells }
        }
    }
}

extension LevelView {
    
    enum Orientation {
        case vertical
        case horizontal
    }
}
