//
//  EndpointSecurityAppDelegate.swift
//  EndpointSecurityApp
//
//  Created by user on 31.10.2024.
//

import SwiftUI
import AppKit
import OSLog

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return false
    }
    
    private func dialogOKCancel(_ title: String,_ description: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = description
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        let answer = self.dialogOKCancel("Application quit warning!", "Should you want to quit?")
        if answer == true
        {
            return .terminateNow
        }
        else
        {
            return .terminateCancel
        }
    }
}
