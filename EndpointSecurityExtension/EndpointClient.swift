import Foundation
@preconcurrency import EndpointSecurity
import OSLog

public class EndpointClient
{
    private var esClient: OpaquePointer?
    private var connected = false
    private var events : [es_event_type_t]
    private var callbacks : [String : (OpaquePointer, UnsafePointer<es_message_t>) -> Bool]
    private var extraConfig : ((OpaquePointer) -> Void)?
    private var clientName : String
    
    init(_ name : String)
    {
        self.clientName = name
        self.callbacks = [String : (OpaquePointer, UnsafePointer<es_message_t>) -> Bool]()
        self.events = [es_event_type_t]()
    }
    
    public func setExtraConfig(_ callback : @escaping (OpaquePointer) -> Void) -> Void
    {
        if (self.connected)
        {
            os_log(OSLogType.info, "[%{public}@] Unable to call extaConfig after start() call", self.clientName)
            return;
        }
        
        self.extraConfig = callback
    }
    
    public func subscribe(_ eventType : es_event_type_t,_ callback : @escaping (OpaquePointer, UnsafePointer<es_message_t>) -> Bool) -> Void
    {
        if (self.connected)
        {
            os_log(OSLogType.info, "[%{public}@] Unable to subscribe after start() call", self.clientName)
            return;
        }
        
        self.events.append(eventType)
        self.callbacks[Utils.esEventTypeToString(eventType)] = callback
    }
    
    public func start() -> Void
    {
        var client: OpaquePointer?
        // Create the client
        
        if (connected)
        {
            os_log(OSLogType.error, "[%{public}@] ESClient already connected", self.clientName)
            return
        }
        
        if (events.count == 0)
        {
            os_log(OSLogType.error, "[%{public}@] ESClient didn't subscribe for any event", self.clientName)
            return
        }
        
        os_log(OSLogType.info, "[%{public}@] started to register", self.clientName)
        
        let creationResult = es_new_client(&client) { (_, message) in
            self.handleEvent(message)
        }

        if (creationResult != ES_NEW_CLIENT_RESULT_SUCCESS)
        {
            os_log(OSLogType.info, "[%{public}@] Failed to create ES Client %{public}@", self.clientName, creationResult.rawValue)
            exit(EXIT_FAILURE)
        }
        
        os_log(OSLogType.info, "[%{public}@] ES Client successfuly created")
        
        let signingResult = es_subscribe(client!, self.events, UInt32(self.events.count))
        if (signingResult != ES_RETURN_SUCCESS)
        {
            os_log(OSLogType.error, "[%{public}@] Failed to subscribe to event source: %{public}@", self.clientName, signingResult.rawValue)
            exit(EXIT_FAILURE)
        }
        
        if (self.extraConfig != nil)
        {
            self.extraConfig!(client!)
        }
        
        self.esClient = client
        self.connected = true
        
        os_log(OSLogType.info, "[%{public}@] ES Client successfuly signed for events %{public}@", self.clientName, self.events)
    }
    
    private func handleEvent(_ message : UnsafePointer<es_message_t>) -> Void
    {
        if (message.pointee.process.pointee.is_es_client)
        {
            es_respond_auth_result(esClient!, message, ES_AUTH_RESULT_ALLOW, true)
            return
        }
        
        if (events.contains(message.pointee.event_type))
        {
            os_log(OSLogType.info, "[%{public}@] %{public}@", self.clientName, Utils.esEventTypeToString(message.pointee.event_type))
            
            // extend lifetime for message
            es_retain_message(message)
            
            let callback = self.callbacks[Utils.esEventTypeToString(message.pointee.event_type)]
            
            // here must be async call
            Task.detached {
                if (!callback!(self.esClient!, message))
                {
                    self.finalizeCallbackCall(message)
                }
                
                // release message
                es_release_message(message)
            }
        }
        else
        {
            finalizeCallbackCall(message)
        }
    }
    
    private func finalizeCallbackCall(_ message : UnsafePointer<es_message_t>)
    {
        switch (message.pointee.event_type)
        {
        case ES_EVENT_TYPE_AUTH_OPEN:
            es_respond_flags_result(self.esClient!, message, Utils.FALL, true);
            break;
        default:
            if (message.pointee.action_type == ES_ACTION_TYPE_AUTH)
            {
                es_respond_auth_result(self.esClient!, message, ES_AUTH_RESULT_ALLOW, true);
            }
            
            break;
        }
    }
}
