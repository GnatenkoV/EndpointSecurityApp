//
//  main.swift
//  EndpointSecurityExtension
//
//  Created by user on 21.10.2024.
//

import Foundation
import EndpointSecurity
import Cocoa
import OSLog

@main
struct App
{
    static var client: OpaquePointer?
    
    static func main()
    {
        // Create the client
        let res = es_new_client(&client) { (client, message) in
            // Do processing on the message received
        }

        if res != ES_NEW_CLIENT_RESULT_SUCCESS {
            exit(EXIT_FAILURE)
        }

        dispatchMain()
        
    }
}
