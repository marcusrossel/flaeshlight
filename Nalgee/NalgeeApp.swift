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
    @AppStorage("showDamageWarning") var showDamageWarning = false
    
    private let torchModel = TorchView.Model()
    private let spotModel = SpotView.Model()
    
    init() {
        UIApplication.shared.isIdleTimerDisabled = true
        UIScrollView.appearance().bounces = false
        UIScreen.main.wantsSoftwareDimming = true
    }
    
    var body: some Scene {
        WindowGroup {
            if showDamageWarning {
                DamageWarningView(isPresented: $showDamageWarning)
            } else {
                ContentView(torchModel: torchModel, spotModel: spotModel)
            }
        }
        .onChange(of: scenePhase) { phase in
            guard case .active = phase else { return }
            torchModel.microphone.reset()
        }
    }
}
