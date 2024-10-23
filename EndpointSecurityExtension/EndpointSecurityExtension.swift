//
//  main.swift
//  EndpointSecurityExtension
//
//  Created by user on 21.10.2024.
//

import Foundation
import EndpointSecurity
import OSLog

@main
struct App
{   
    static var client : EndpointClient?
    
    static func main()
    {
        os_log(OSLogType.fault, "init client")
        
        client = EndpointClient("client1")
        
        client!.subscribe(ES_EVENT_TYPE_AUTH_SIGNAL, callback: onAuthProcSignal)
        client!.subscribe(ES_EVENT_TYPE_AUTH_OPEN, callback: onAuthFileOpen)
        client!.start()
        
        dispatchMain()
    }
    
    static func onAuthFileOpen(_ client : OpaquePointer, message : UnsafePointer<es_message_t>) -> Bool
    {
        //let prefix = "/Users/user/Documents/Projects"
        
        return false
    }
    
    static func onAuthProcSignal(_ client : OpaquePointer, message : UnsafePointer<es_message_t>) -> Bool
    {
        os_log(OSLogType.info, "Signal received")
        
        let signing_id = message.pointee.event.signal.target.pointee.signing_id
        let boundleId = NSString(bytes: signing_id.data, length: Int(signing_id.length), encoding: NSASCIIStringEncoding)
        let appId : NSString = "com.apriorit.hnatenko.EndpointSecurityApp"
        
        let signal = message.pointee.event.signal.sig
        
        if (boundleId == appId &&
            (signal == SIGKILL      // kill program
             || signal == SIGSTOP   // stop (cannot be caught or ignored)
             || signal == SIGTSTP   // stop signal generated from keyboard
             || signal == SIGINT    // interrupt program
             || signal == SIGQUIT   // quit program
             || signal == SIGABRT)) // abort program
        {
            es_respond_auth_result(client, message, ES_AUTH_RESULT_DENY, false);
        }
        else
        {
            es_respond_auth_result(client, message, ES_AUTH_RESULT_ALLOW, true);
        }
        os_log(OSLogType.info, "%{public}@", boundleId!)
        return true
    }
}
