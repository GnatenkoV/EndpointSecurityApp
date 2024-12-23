//
//  MainExtension.swift
//  EndpointSecurityExtension
//
//  Created by user on 24.10.2024.
//

import Foundation
import EndpointSecurity
import OSLog

class HandlersStorage {
        
    public static func onAuthProcSignal(_ client: OpaquePointer, message: UnsafePointer<es_message_t>) -> Bool
    {
        let signing_id = message.pointee.event.signal.target.pointee.signing_id
        let bundleId = NSString(bytes: signing_id.data, length: Int(signing_id.length), encoding: NSASCIIStringEncoding)
        let appId: NSString = "com.apriorit.hnatenko.EndpointSecurityApp"
        
        let signal = message.pointee.event.signal.sig
        os_log(OSLogType.debug, "[client1] Received signal: %{public}d for bundleId: %{public}@ %{public}d", signal, bundleId!)
        
        if (bundleId == appId &&
            (signal == SIGKILL      // kill program
             || signal == SIGSTOP   // stop (cannot be caught or ignored)
             || signal == SIGTSTP   // stop signal generated from keyboard
             || signal == SIGINT    // interrupt program
             || signal == SIGQUIT   // quit program
             || signal == SIGTERM   // terminate process
             || signal == SIGHUP    // terminate
             || signal == 0         // unknown signal that stop app
             || signal == SIGABRT)) // abort program
        {
            os_log(OSLogType.debug, "[client1] Deny signal: %{public}d", signal)
            es_respond_auth_result(client, message, ES_AUTH_RESULT_DENY, false);
            return true
        }
        

        return false
    }
    
    public static func onAuthFileOpenConfig(_ client: OpaquePointer) -> Void
    {
        es_unmute_all_target_paths(client)
        es_invert_muting(client, ES_MUTE_INVERSION_TYPE_TARGET_PATH)
        es_mute_path(client, "/Users/user/Downloads", ES_MUTE_PATH_TYPE_TARGET_PREFIX)
        es_mute_path(client, "/Library/Application Support/com.apriorit.hnatenko.EndpointSecurityApp", ES_MUTE_PATH_TYPE_TARGET_PREFIX)
    }
    
    public static func onAuthFileOpen(_ client: OpaquePointer, message: UnsafePointer<es_message_t>) -> Bool
    {
        let allowedBundleIds: [NSString] = ["com.apple.finder", "com.apple.safari", "com.apple.dt.XCBBuildService", "com.apple.dt.Xcode", "com.apple.ibtool", "com.apple.mdworker_shared", "com.apriorit.hnatenko.EndpointSecurityApp", "com.apriorit.hnatenko.EndpointSecurityApp.Extension"]
        
        let readonlyBundleIds: [NSString] = ["com.barebones.bbedit"]
        
        let protectedPaths = ["/Users/user/Downloads", "/Library/Application Support/com.apriorit.hnatenko.EndpointSecurityApp"]
        let filePathPointer = message.pointee.event.open.file.pointee.path
        let filePath = NSString(bytes: filePathPointer.data, length: Int(filePathPointer.length), encoding: NSASCIIStringEncoding)
        
        os_log(OSLogType.debug, "[client2] Folder access %{public}@", filePath!)
        
        for i in 0..<protectedPaths.count
        {
            let protectedPath = protectedPaths[i]
            
            if (filePath!.contains(protectedPath))
            {
                os_log(OSLogType.debug, "[client2] Trying to get access for %{public}@", filePath!)
                
                let signing_id = message.pointee.process.pointee.signing_id
                let bundleId = NSString(bytes: signing_id.data, length: Int(signing_id.length), encoding: NSASCIIStringEncoding)
             
                os_log(OSLogType.debug, "[client2] Checking access for bundleId:%{public}@", bundleId!)
                
                if (allowedBundleIds.contains(bundleId!))
                {
                    return false
                }
                else if (readonlyBundleIds.contains(bundleId!))
                {
                    os_log(OSLogType.debug, "[client2] Access readonly for %{public}@ to %{public}@", bundleId!, filePath!)
                    es_respond_flags_result(client, message, Utils.getAllowAccessExceptFlags(Utils.FWRITE), false);
                    return true
                }

                os_log(OSLogType.debug, "[client2] Access denied for %{public}@ to %{public}@", bundleId!, filePath!)
                es_respond_flags_result(client, message, Utils.FNONE, false);
                
                return true
            }
        }
        
        return false
    }
}
