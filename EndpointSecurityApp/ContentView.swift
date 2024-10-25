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
    @ObservedObject private var installationManager = InstallationManager()
    
    init()
    {
        
    }
    
    private func onInstallationButtonPress() -> Void
    {
        installationManager.activate()
    }
    
    private func onUninstallationButtonPress() -> Void
    {
        installationManager.deactivate()
    }
    
    var body: some View {
        VStack {
            Image(systemName: "puzzlepiece.extension")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            if (!$installationManager.isEndpointSecurityInstalled.wrappedValue && !$installationManager.uninstallingInProgress.wrappedValue)
            {
                Button("Install Extension", systemImage : "square.and.arrow.down", action: onInstallationButtonPress)
                    .cornerRadius(5)
                    .padding(.top, 10)
            }

            if ($installationManager.isEndpointSecurityInstalled.wrappedValue && !$installationManager.uninstallingInProgress.wrappedValue)
            {
                Button("Update Extension", systemImage : "arrow.clockwise.square", action: onInstallationButtonPress)
                    .cornerRadius(5)
                    .padding(.top, 10)
            }

            if ($installationManager.isEndpointSecurityInstalled.wrappedValue && !$installationManager.uninstallingInProgress.wrappedValue)
            {
                Button("Uninstall Extension", systemImage : "xmark.square", action: onUninstallationButtonPress)
                    .cornerRadius(5)
                    .padding(.top, 10)
            }
            
            if ($installationManager.uninstallingInProgress.wrappedValue)
            {
                Text("Uninstalling in progress!")
            }
            
            ScrollView {
                VStack {
                    Text($installationManager.status.wrappedValue)
                        .lineLimit(nil)
                        .background(.gray)
                        .cornerRadius(5.0)
                }
                .frame(idealWidth: 250, maxWidth: 300, idealHeight: 200, maxHeight: 200)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
