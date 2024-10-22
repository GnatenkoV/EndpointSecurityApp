//
//  ContentView.swift
//  EndpointSecurityApp
//
//  Created by user on 21.10.2024.
//

import SwiftUI
import OSLog

extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(self.hidden()) : AnyView(self)
    }
}

struct ContentView: View {
    
    @State private var viewDidLoad = false
    @ObservedObject private var installationManager = InstallationManager()
    
    init()
    {
        
    }
    
    private func onInstallationButtonPress() -> Void
    {
        installationManager.activate()
    }
    
    private func onDeinstallationButtonPressed() -> Void
    {
        
    }
    
    private func onViewDidLoad() -> Void
    {
        os_log("view loaded")
    }
    
    var body: some View {
        VStack {
            Image(systemName: "puzzlepiece.extension")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            if (!$installationManager.isEndpointSecurityInstalled.wrappedValue)
            {
                Button("Install", systemImage : "square.and.arrow.down", action: onInstallationButtonPress)
                    .cornerRadius(5)
                    .padding(.top, 10)
            }

            if ($installationManager.isEndpointSecurityInstalled.wrappedValue)
            {
                Button("Update", systemImage : "arrow.clockwise.square", action: onInstallationButtonPress)
                    .cornerRadius(5)
                    .padding(.top, 10)
            }

            if ($installationManager.isEndpointSecurityInstalled.wrappedValue)
            {
                Button("Uninstall", systemImage : "xmark.square", action: onInstallationButtonPress)
                    .cornerRadius(5)
                    .padding(.top, 10)
            }
            
            ScrollView {
                VStack {
                    Text($installationManager.status.wrappedValue)
                        .lineLimit(nil)
                        .background(.gray)
                }
                .frame(idealWidth: 250, maxWidth: 300)
            }
        }
        .padding()
        .onAppear {
            if (self.viewDidLoad == false)
            {
                self.viewDidLoad = true
                
                onViewDidLoad()
            }
        }
    }
    

}

#Preview {
    ContentView()
}
