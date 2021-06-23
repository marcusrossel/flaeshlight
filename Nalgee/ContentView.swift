//
//  ContentView.swift
//  Nalgee
//
//  Created by Marcus Rossel on 18.06.21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var torchModel: TorchView.Model
    @ObservedObject var spotModel: SpotView.Model
    
    @State private var selectedTab: Tab = .spot
    
    private var showSelectedTabUI: Bool {
        switch selectedTab {
        case .torch: return torchModel.showControls
        case .spot:  return spotModel.showControls
        }
    }
    
    private var selectedTabIsEnabled: Bool {
        switch selectedTab {
        case .torch: return torchModel.isEnabled
        case .spot:  return spotModel.isEnabled
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    Group {
                        SpotView(model: spotModel).tag(Tab.spot)
                        TorchView(model: torchModel).tag(Tab.torch)
                    }
                    .padding(.bottom, 32)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: showSelectedTabUI ? .automatic : .never))
                .disabled(!showSelectedTabUI)
                
                if showSelectedTabUI && selectedTabIsEnabled {
                    hideUIButton
                }
            }
            
            if !showSelectedTabUI { hiddenUIView }
        }
        .onChange(of: selectedTab) { tab in
            switch tab {
            case .torch:
                torchModel.isActive = true
                spotModel.isActive = false
            case .spot:
                torchModel.isActive = false
                spotModel.isActive = true
            }
        }
    }
    
    @ViewBuilder private var hiddenUIView: some View {
        Group {
            switch selectedTab {
            case .torch:
                VStack(spacing: 16) {
                    Image(systemName: "waveform")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                    
                    Text("Tap to return.")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                    .multilineTextAlignment(.center)
                }
                .foregroundColor(Color(.quaternaryLabel))
                .padding(32)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .spot:
                Color.clear
            }
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture {
            switch selectedTab {
            case .torch: torchModel.showControls = true
            case .spot:  spotModel.showControls = true
            }
        }
        .statusBar(hidden: true)
    }
    
    @ViewBuilder private var hideUIButton: some View {
        Button {
            switch selectedTab {
            case .torch: torchModel.showControls = false
            case .spot:  spotModel.showControls = false
            }
        } label: {
            Text("Hide Controls")
                .font(.system(size: 18, design: .rounded).weight(.bold))
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .contentShape(Rectangle())
                .padding(.horizontal)
        }
    }
}

extension ContentView {
    
    enum Tab: Identifiable {
        
        case torch
        case spot
        
        var id: Self { self }
    }
}
