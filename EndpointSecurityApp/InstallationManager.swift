//
//  InstallationManager.swift
//  EndpointSecurityApp
//
//  Created by user on 21.10.2024.
//

import Foundation
import SystemExtensions
import OSLog

class InstallationManager: NSObject, ObservableObject
{ 
    private let extensionBundleId: String = "com.apriorit.hnatenko.EndpointSecurityApp.Extension"
    private let appFolder: String = "/Library/Application Support/com.apriorit.hnatenko.EndpointSecurityApp"
    private var currentRequest: OSSystemExtensionRequest?
    
    @Published public var status = ""
    @Published public var isEndpointSecurityInstalled = false
    @Published public var uninstallingInProgress = false
    
    override init()
    {
        super.init()

        isEndpointSecurityInstalled = self.isExtensionInstalled()
        
        createAppFilesIfNotExists()
        
        os_log(OSLogType.debug, "args: \(CommandLine.arguments)")
        
        if (CommandLine.arguments.contains("-uninstall"))
        {
            uninstallingInProgress = true
            
            if (isEndpointSecurityInstalled)
            {
                deactivate()
            }
            else
            {
                exit(0)
            }
        }
    }
    
    public func isExtensionInstalled() -> Bool
    {
        do
        {
            let url = URL(fileURLWithPath: "/Library/SystemExtensions/db.plist")
            let data = try Data(contentsOf: url)
            
            let decoder = PropertyListDecoder()
            let list = try! decoder.decode(ExtensionsPropertyList.self, from: data)
            
            for ext in list.extensions
            {
                if (ext.identifier == extensionBundleId && (ext.state == "activated_enabled" || ext.state == "activated_waiting_for_user"))
                {
                    return true
                }
            }
        }
        catch let error
        {
            os_log("%@", error.localizedDescription)
        }
        
        return false
    }
    
    public func activate() -> Void
    {
        status = ""
        
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionBundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        currentRequest = request
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    public func deactivate() -> Void
    {
        status = ""
        
        let request = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionBundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    private func createAppFilesIfNotExists() -> Void
    {
        do
        {
            //  Find Application Support directory
            let directoryURL = URL(fileURLWithPath: appFolder)
            if (!FileManager.default.fileExists(atPath: appFolder))
            {
                try FileManager.default.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Create test document
            let documentPath = directoryURL.appendingPathComponent("TestFile.txt")
            if (!FileManager.default.fileExists(atPath: appFolder + "/TestFile.txt"))
            {
                let testInfo = "test document info"
                try testInfo.write(to: documentPath, atomically: false, encoding: String.Encoding.utf8)
            }
        }
        catch
        {
          print("An error occured")
        }
    }
}
