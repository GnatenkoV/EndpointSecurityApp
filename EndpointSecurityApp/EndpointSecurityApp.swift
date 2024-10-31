//
//  EndpointSecurityAppApp.swift
//  EndpointSecurityApp
//
//  Created by user on 21.10.2024.
//

import SwiftUI
import Foundation
import AppKit
import OSLog

@main
struct EndpointSecurityApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
