//
//  ContentView.swift
//  EndpointSecurityApp
//
//  Created by user on 21.10.2024.
//

import SwiftUI
import OSLog

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
        Grid(alignment: .center) {
            GridRow {
                Image(systemName: "puzzlepiece.extension")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .padding(10)
            }
            
            if (!$installationManager.isEndpointSecurityInstalled.wrappedValue && !$installationManager.uninstallingInProgress.wrappedValue)
            {
                GridRow {
                    Button("Install Extension", systemImage: "square.and.arrow.down", action: onInstallationButtonPress)
                        .cornerRadius(5)
                }
            }
            
            if ($installationManager.isEndpointSecurityInstalled.wrappedValue && !$installationManager.uninstallingInProgress.wrappedValue)
            {
                GridRow {
                    Button("Update Extension", systemImage: "arrow.clockwise.square", action: onInstallationButtonPress)
                        .cornerRadius(5)
                }
            }
            
            if ($installationManager.isEndpointSecurityInstalled.wrappedValue && !$installationManager.uninstallingInProgress.wrappedValue)
            {
                GridRow {
                    Button("Uninstall Extension", systemImage: "xmark.square", action: onUninstallationButtonPress)
                        .cornerRadius(5)
                }
                

            }
            
            if ($installationManager.uninstallingInProgress.wrappedValue) {
                GridRow {
                    Text("Uninstalling in progress!")
                }
            }
            
            GridRow {
                ScrollView {
                    VStack {
                        Text($installationManager.status.wrappedValue)
                            .lineLimit(nil)
                    }
                }.frame(idealWidth: 250, maxWidth: 300, minHeight: 0, idealHeight: 200, maxHeight: 200)
                .background(.gray)
                .cornerRadius(5.0)
                .padding(.top, 10)
            }

        }
        .frame(minWidth: 100, idealWidth: 200, maxWidth: 300, minHeight: 300, idealHeight: 400, maxHeight: 600)
        .padding()
    }
}

#Preview {
    ContentView()
}
