//
//  Utils.swift
//  EndpointSecurityExtension
//
//  Created by user on 23.10.2024.
//

import Foundation
import EndpointSecurity

class Utils {
    
    public static let FREAD : UInt32 = 0x00000001
    public static let FWRITE : UInt32 = 0x00000002
    public static let FALL : UInt32 = 0xffffffff
    public static let FNONE : UInt32 = 0x00000000
    
    static func getAllowAccessExceptFlags(_ flags : UInt32) -> UInt32
    {
        return self.FALL & ~flags;
    }
    
    static func esEventTypeToString(_ eventType : es_event_type_t) -> String
    {
        switch(eventType)
        {
        case ES_EVENT_TYPE_NOTIFY_RENAME:
            return "ES_EVENT_TYPE_NOTIFY_RENAME"
        case ES_EVENT_TYPE_AUTH_EXEC:
            return "ES_EVENT_TYPE_AUTH_EXEC"
        case ES_EVENT_TYPE_AUTH_OPEN:
            return "ES_EVENT_TYPE_AUTH_OPEN"
        case ES_EVENT_TYPE_AUTH_KEXTLOAD:
            return "ES_EVENT_TYPE_AUTH_KEXTLOAD"
        case ES_EVENT_TYPE_AUTH_MMAP:
            return "ES_EVENT_TYPE_AUTH_MMAP"
        case ES_EVENT_TYPE_AUTH_MPROTECT:
            return "ES_EVENT_TYPE_AUTH_MPROTECT"
        case ES_EVENT_TYPE_AUTH_MOUNT:
            return "ES_EVENT_TYPE_AUTH_MOUNT"
        case ES_EVENT_TYPE_AUTH_RENAME:
            return "ES_EVENT_TYPE_AUTH_RENAME"
        case ES_EVENT_TYPE_AUTH_SIGNAL:
            return "ES_EVENT_TYPE_AUTH_SIGNAL"
        case ES_EVENT_TYPE_AUTH_UNLINK:
            return "ES_EVENT_TYPE_AUTH_UNLINK"
        case ES_EVENT_TYPE_AUTH_FILE_PROVIDER_MATERIALIZE:
            return "ES_EVENT_TYPE_AUTH_FILE_PROVIDER_MATERIALIZE"
        case ES_EVENT_TYPE_AUTH_FILE_PROVIDER_UPDATE:
            return "ES_EVENT_TYPE_AUTH_FILE_PROVIDER_UPDATE"
        case ES_EVENT_TYPE_AUTH_READLINK:
            return "ES_EVENT_TYPE_AUTH_READLINK"
        case ES_EVENT_TYPE_AUTH_TRUNCATE:
            return "ES_EVENT_TYPE_AUTH_TRUNCATE"
        case ES_EVENT_TYPE_AUTH_LINK:
            return "ES_EVENT_TYPE_AUTH_LINK"
        case ES_EVENT_TYPE_AUTH_CREATE:
            return "ES_EVENT_TYPE_AUTH_CREATE"
        case ES_EVENT_TYPE_AUTH_SETATTRLIST:
            return "ES_EVENT_TYPE_AUTH_SETATTRLIST"
        case ES_EVENT_TYPE_AUTH_SETEXTATTR:
            return "ES_EVENT_TYPE_AUTH_SETEXTATTR"
        case ES_EVENT_TYPE_AUTH_SETFLAGS:
            return "ES_EVENT_TYPE_AUTH_SETFLAGS"
        case ES_EVENT_TYPE_AUTH_SETMODE:
            return "ES_EVENT_TYPE_AUTH_SETMODE"
        case ES_EVENT_TYPE_AUTH_SETOWNER:
            return "ES_EVENT_TYPE_AUTH_SETOWNER"
        case ES_EVENT_TYPE_AUTH_CHDIR:
            return "ES_EVENT_TYPE_AUTH_CHDIR"
        case ES_EVENT_TYPE_AUTH_GETATTRLIST:
            return "ES_EVENT_TYPE_AUTH_GETATTRLIST"
        case ES_EVENT_TYPE_AUTH_CHROOT:
            return "ES_EVENT_TYPE_AUTH_CHROOT"
        case ES_EVENT_TYPE_AUTH_UTIMES:
            return "ES_EVENT_TYPE_AUTH_UTIMES"
        case ES_EVENT_TYPE_AUTH_CLONE:
            return "ES_EVENT_TYPE_AUTH_CLONE"
        case ES_EVENT_TYPE_AUTH_GETEXTATTR:
            return "ES_EVENT_TYPE_AUTH_GETEXTATTR"
        case ES_EVENT_TYPE_AUTH_LISTEXTATTR:
            return "ES_EVENT_TYPE_AUTH_LISTEXTATTR"
        case ES_EVENT_TYPE_AUTH_READDIR:
            return "ES_EVENT_TYPE_AUTH_READDIR"
        case ES_EVENT_TYPE_AUTH_DELETEEXTATTR:
            return "ES_EVENT_TYPE_AUTH_DELETEEXTATTR"
        case ES_EVENT_TYPE_AUTH_FSGETPATH:
            return "ES_EVENT_TYPE_AUTH_FSGETPATH"
        case ES_EVENT_TYPE_AUTH_SETTIME:
            return "ES_EVENT_TYPE_AUTH_SETTIME"
        case ES_EVENT_TYPE_AUTH_EXCHANGEDATA:
            return "ES_EVENT_TYPE_AUTH_EXCHANGEDATA"
        case ES_EVENT_TYPE_AUTH_PROC_CHECK:
            return "ES_EVENT_TYPE_AUTH_PROC_CHECK"
        case ES_EVENT_TYPE_AUTH_GET_TASK:
            return "ES_EVENT_TYPE_AUTH_GET_TASK"
        case ES_EVENT_TYPE_AUTH_PROC_SUSPEND_RESUME:
            return "ES_EVENT_TYPE_AUTH_PROC_SUSPEND_RESUME"
        case ES_EVENT_TYPE_AUTH_GET_TASK_READ:
            return "ES_EVENT_TYPE_AUTH_GET_TASK_READ"
        case ES_EVENT_TYPE_AUTH_COPYFILE:
            return "ES_EVENT_TYPE_AUTH_COPYFILE"
        case ES_EVENT_TYPE_LAST:
            return "ES_EVENT_TYPE_LAST"
        default:
            return "\(eventType.rawValue)"
        }
    }
    
    static func esEventTypeFromString(_ eventType : String) -> es_event_type_t
    {
        switch(eventType)
        {
        case "ES_EVENT_TYPE_NOTIFY_RENAME":
            return ES_EVENT_TYPE_NOTIFY_RENAME
        case "ES_EVENT_TYPE_AUTH_EXEC":
            return ES_EVENT_TYPE_AUTH_EXEC
        case "ES_EVENT_TYPE_AUTH_OPEN":
            return ES_EVENT_TYPE_AUTH_OPEN
        case "ES_EVENT_TYPE_AUTH_KEXTLOAD":
            return ES_EVENT_TYPE_AUTH_KEXTLOAD
        case "ES_EVENT_TYPE_AUTH_MMAP":
            return ES_EVENT_TYPE_AUTH_MMAP
        case "ES_EVENT_TYPE_AUTH_MPROTECT":
            return ES_EVENT_TYPE_AUTH_MPROTECT
        case "ES_EVENT_TYPE_AUTH_MOUNT":
            return ES_EVENT_TYPE_AUTH_MOUNT
        case "ES_EVENT_TYPE_AUTH_RENAME":
            return ES_EVENT_TYPE_AUTH_RENAME
        case "ES_EVENT_TYPE_AUTH_SIGNAL":
            return ES_EVENT_TYPE_AUTH_SIGNAL
        case "ES_EVENT_TYPE_AUTH_UNLINK":
            return ES_EVENT_TYPE_AUTH_UNLINK
        case "ES_EVENT_TYPE_AUTH_FILE_PROVIDER_MATERIALIZE":
            return ES_EVENT_TYPE_AUTH_FILE_PROVIDER_MATERIALIZE
        case "ES_EVENT_TYPE_AUTH_FILE_PROVIDER_UPDATE":
            return ES_EVENT_TYPE_AUTH_FILE_PROVIDER_UPDATE
        case "ES_EVENT_TYPE_AUTH_READLINK":
            return ES_EVENT_TYPE_AUTH_READLINK
        case "ES_EVENT_TYPE_AUTH_TRUNCATE":
            return ES_EVENT_TYPE_AUTH_TRUNCATE
        case "ES_EVENT_TYPE_AUTH_LINK":
            return ES_EVENT_TYPE_AUTH_LINK
        case "ES_EVENT_TYPE_AUTH_CREATE":
            return ES_EVENT_TYPE_AUTH_CREATE
        case "ES_EVENT_TYPE_AUTH_SETATTRLIST":
            return ES_EVENT_TYPE_AUTH_SETATTRLIST
        case "ES_EVENT_TYPE_AUTH_SETEXTATTR":
            return ES_EVENT_TYPE_AUTH_SETEXTATTR
        case "ES_EVENT_TYPE_AUTH_SETFLAGS":
            return ES_EVENT_TYPE_AUTH_SETFLAGS
        case "ES_EVENT_TYPE_AUTH_SETMODE":
            return ES_EVENT_TYPE_AUTH_SETMODE
        case "ES_EVENT_TYPE_AUTH_SETOWNER":
            return ES_EVENT_TYPE_AUTH_SETOWNER
        case "ES_EVENT_TYPE_AUTH_CHDIR":
            return ES_EVENT_TYPE_AUTH_CHDIR
        case "ES_EVENT_TYPE_AUTH_GETATTRLIST":
            return ES_EVENT_TYPE_AUTH_GETATTRLIST
        case "ES_EVENT_TYPE_AUTH_CHROOT":
            return ES_EVENT_TYPE_AUTH_CHROOT
        case "ES_EVENT_TYPE_AUTH_UTIMES":
            return ES_EVENT_TYPE_AUTH_UTIMES
        case "ES_EVENT_TYPE_AUTH_CLONE":
            return ES_EVENT_TYPE_AUTH_CLONE
        case "ES_EVENT_TYPE_AUTH_GETEXTATTR":
            return ES_EVENT_TYPE_AUTH_GETEXTATTR
        case "ES_EVENT_TYPE_AUTH_LISTEXTATTR":
            return ES_EVENT_TYPE_AUTH_LISTEXTATTR
        case "ES_EVENT_TYPE_AUTH_READDIR":
            return ES_EVENT_TYPE_AUTH_READDIR
        case "ES_EVENT_TYPE_AUTH_DELETEEXTATTR":
            return ES_EVENT_TYPE_AUTH_DELETEEXTATTR
        case "ES_EVENT_TYPE_AUTH_FSGETPATH":
            return ES_EVENT_TYPE_AUTH_FSGETPATH
        case "ES_EVENT_TYPE_AUTH_SETTIME":
            return ES_EVENT_TYPE_AUTH_SETTIME
        case "ES_EVENT_TYPE_AUTH_EXCHANGEDATA":
            return ES_EVENT_TYPE_AUTH_EXCHANGEDATA
        case "ES_EVENT_TYPE_AUTH_PROC_CHECK":
            return ES_EVENT_TYPE_AUTH_PROC_CHECK
        case "ES_EVENT_TYPE_AUTH_GET_TASK":
            return ES_EVENT_TYPE_AUTH_GET_TASK
        case "ES_EVENT_TYPE_AUTH_PROC_SUSPEND_RESUME":
            return ES_EVENT_TYPE_AUTH_PROC_SUSPEND_RESUME
        case "ES_EVENT_TYPE_AUTH_GET_TASK_READ":
            return ES_EVENT_TYPE_AUTH_GET_TASK_READ
        case "ES_EVENT_TYPE_AUTH_COPYFILE":
            return ES_EVENT_TYPE_AUTH_COPYFILE
        default:
            return ES_EVENT_TYPE_LAST
        }
    }
}
