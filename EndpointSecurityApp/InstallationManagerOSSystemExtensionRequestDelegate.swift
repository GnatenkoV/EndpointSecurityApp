import Foundation
import OSLog
import SystemExtensions

extension InstallationManager: OSSystemExtensionRequestDelegate
{
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
