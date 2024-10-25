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
    private let extensionName : String = "com.apriorit.hnatenko.EndpointSecurityApp.Extension.systemextension"
    private let appFolder : String = "/Library/Application Support/com.apriorit.hnatenko.EndpointSecurityApp"
    private var currentRequest : OSSystemExtensionRequest?
    
    @Published public var status = ""
    @Published public var isEndpointSecurityInstalled = false
    @Published public var uninstallingInProgress = false
    
    override init()
    {
        super.init()

        isEndpointSecurityInstalled = self.isExtensionInstalled()
        
        createAppFilesIfNotExists()
        
        os_log(OSLogType.info, "args: \(CommandLine.arguments)")
        
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
                if (ext["identifier"] as! String == extensionBoundleId && ext["state"] as! String == "activated_enabled")
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
    
    private func createAppFilesIfNotExists() -> Void
    {
        do
        {
            //  Find Application Support directory
            let directoryURL = URL(fileURLWithPath : appFolder)
            if (!FileManager.default.fileExists(atPath: appFolder))
            {
                try FileManager.default.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            
            // Create test document
            let documentPath = directoryURL.appendingPathComponent("TestFile.txt")
            let testInfo = "test document info"
            try testInfo.write(to: documentPath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch
        {
          print("An error occured")
        }
    }
    
    /*private func clearExtensionFiles() -> Void
    {
        let systemExtensionURL = URL(fileURLWithPath: extensionsFolder)
        var foldersToDelete = [URL]()
        
        do {
            let resourceKeys : [URLResourceKey] = [.isDirectoryKey, .isApplicationKey]
            let enumerator = FileManager.default.enumerator(at: systemExtensionURL,
                                    includingPropertiesForKeys: resourceKeys,
                                                       options: [.skipsHiddenFiles], errorHandler:
                                                                { (url, error) -> Bool in
                os_log(OSLogType.info, "enumerator error at: %{public}@, error:%{public}@", url.absoluteString, error.localizedDescription)
                                                                return true
            })!
            
            for case let fileURL as URL in enumerator
            {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                
                if (resourceValues.isDirectory!)
                {
                    let contentEnumerator = try FileManager.default.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil, options: [])
                    
                    for ext in contentEnumerator
                    {
                        if (ext.isFileURL && ext.path.hasSuffix(extensionName))
                        {
                            foldersToDelete.append(fileURL)
                            break
                        }
                    }
                }
            }
            
            //for folderPath in foldersToDelete
            //{
            //    if (FileManager.default.fileExists(atPath: folderPath.path))
            //    {
            //        try FileManager.default.removeItem(at: folderPath)
            //    }
            //}
        } catch {
            os_log(OSLogType.error, "%{public}@", error.localizedDescription)
        }
    }*/
    
    @objc func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) -> Void
    {
        os_log("System extension request failed %@", error.localizedDescription)
        
        status += "\nSystem extension request failed: \(error.localizedDescription)"
        
        if (self.uninstallingInProgress)
        {
            exit(0)
        }
        
        isEndpointSecurityInstalled = self.isExtensionInstalled()
    }
      
      
    @objc func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) -> Void
    {
        os_log("System extension requires user approval")
        
        status += "\nSystem extension requires user approval"
        
        isEndpointSecurityInstalled = self.isExtensionInstalled()
    }
      
      
    @objc func request(_ request: OSSystemExtensionRequest,
                 actionForReplacingExtension existing: OSSystemExtensionProperties,
                 withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction
    {
        os_log("Replacing extension: %@ %@", existing, ext)
        
        status += "\nReplacing extension: \(existing) \(ext)"
        
        isEndpointSecurityInstalled = self.isExtensionInstalled()
        
        return .replace
    }
      
      
    @objc func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) -> Void
    {
        os_log("System extension activating request result: %d", result.rawValue)
        
        status += "\nSystem extension activating request result: \(result.rawValue)"
        
        if (self.uninstallingInProgress)
        {
            exit(0)
        }
        
        isEndpointSecurityInstalled = self.isExtensionInstalled()
        
        
    }
}
