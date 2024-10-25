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
    static var client1 : EndpointClient?
    static var client2 : EndpointClient?
    
    static private let appFolder : String = "/Library/Application Support/com.apriorit.hnatenko.EndpointSecurityApp"
    
    static func createTestFiles() -> Void
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
            os_log(OSLogType.error, "failed to create test file")
        }
        
    }
    
    static func main()
    {
        os_log(OSLogType.fault, "init client")
        
        createTestFiles();
        
        client1 = EndpointClient("client1")
        client2 = EndpointClient("client2")
        
        // process protection
        client1!.subscribe(ES_EVENT_TYPE_AUTH_SIGNAL, HandlersStorage.onAuthProcSignal)
        client1!.start()
        
        // denie access and readonly
        client2!.subscribe(ES_EVENT_TYPE_AUTH_OPEN, HandlersStorage.onAuthFileOpen)
        client2!.setExtraConfig(HandlersStorage.onAuthFileOpenConfig)
        client2!.start()
        
        dispatchMain()
    }
}
