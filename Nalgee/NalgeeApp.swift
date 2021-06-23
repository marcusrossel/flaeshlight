//
//  NalgeeApp.swift
//  Nalgee
//
//  Created by Marcus Rossel on 17.06.21.
//

import SwiftUI

@main
struct NalgeeApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var torchModel = TorchView.Model()
    @StateObject var spotModel = SpotView.Model()
    
    init() {
        UIApplication.shared.isIdleTimerDisabled = true
        UIScrollView.appearance().bounces = false
        UIScreen.main.wantsSoftwareDimming = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(torchModel: torchModel, spotModel: spotModel)
        }
        .onChange(of: scenePhase) { phase in
            guard case .active = phase else { return }
            torchModel.microphone.reset()
        }
    }
}
