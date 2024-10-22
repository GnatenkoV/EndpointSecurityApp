//
//  InstallationManager.swift
//  EndpointSecurityApp
//
//  Created by user on 21.10.2024.
//

import Foundation
import SystemExtensions
import OSLog

class InstallationManager : NSObject, OSSystemExtensionRequestDelegate, ObservableObject
{ 
    private let extensionBoundleId : String = "com.apriorit.hnatenko.EndpointSecurityApp.Extension"
    //private let extensionBoundleId : String = "com.apriorit.SampleEndpointApp.Extension"
    private var currentRequest : OSSystemExtensionRequest?
    
    @Published public var status = ""
    @Published public var isEndpointSecurityInstalled = false
    
    override init()
    {
        super.init()

        isEndpointSecurityInstalled = self.isExtensionInstalled()
    }
    
    private func isExtensionInstalled() -> Bool
    {
        do
        {
            let url = URL(fileURLWithPath: "/Library/SystemExtensions/db.plist")
            let data = try Data(contentsOf: url)
            var format = PropertyListSerialization.PropertyListFormat.xml
            //convert the plist data to a Swift Dictionary
            let plistDict = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: &format) as! [String : AnyObject]
            //access the values in the dictionary
            for ext in plistDict["extensions"] as! [[String : AnyObject]]
            {
                if (ext["identifier"] as! String == extensionBoundleId)
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
        
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionBoundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        currentRequest = request
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    public func deactivate() -> Void
    {
        status = ""
        
        let request = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionBoundleId, queue: DispatchQueue.main)
        request.delegate = self
        
        OSSystemExtensionManager.shared.submitRequest(request)
    }
    
    @objc func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) -> Void
    {
        os_log("System extension request failed %@", error.localizedDescription)
        
        status += "\nSystem extension request failed: \(error.localizedDescription)"
    }
      
      
    @objc func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) -> Void
    {
        os_log("System extension requires user approval")
        
        status += "\nSystem extension requires user approval"
    }
      
      
    @objc func request(_ request: OSSystemExtensionRequest,
                 actionForReplacingExtension existing: OSSystemExtensionProperties,
                 withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction
    {
        os_log("Replacing extension: %@ %@", existing, ext)
        
        status += "\nReplacing extension: \(existing) \(ext)"
        
        return .replace
    }
      
      
    @objc func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) -> Void
    {
        os_log("System extension activating request result: %d", result.rawValue)
        
        status += "\nSystem extension activating request result: \(result.rawValue)"
    }
}
