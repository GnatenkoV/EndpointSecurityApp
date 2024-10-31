//
//  ExtensionData.swift
//  EndpointSecurityApp
//
//  Created by user on 31.10.2024.
//

struct BundleVersionData: Decodable {
    var CFBundleShortVersionString: String
    var CFBundleVersion: String
    
    private enum CodingKeys: String, CodingKey {
        case CFBundleShortVersionString = "CFBundleShortVersionString"
        case CFBundleVersion = "CFBundleVersion"
    }
}

struct StagedBundleURLData: Decodable {
    var relative: String
    
    private enum CodingKeys: String, CodingKey {
        case relative = "relative"
    }
}

struct ContainerData: Decodable {
    var bundlePath: String
    
    private enum CodingKeys: String, CodingKey {
        case bundlePath = "bundlePath"
    }
}

struct ExtensionData: Decodable {
    var state: String
    var categories: [String]
    var originPath: String
    //additionalLaunchdPlistEntries - ignore
    var bundleVersion: BundleVersionData?
    var identifier: String
    var stagedBundleURL: StagedBundleURLData?
    var container: ContainerData?
    var uniqueID: String
    // stagedCdhashes - ignore
    var teamID: String
    
    private enum CodingKeys: String, CodingKey {
        case state = "state"
        case categories = "categories"
        case originPath = "originPath"
        //case additionalLaunchdPlistEntries = "additionalLaunchdPlistEntries"
        case bundleVersion = "bundleVersion"
        case identifier = "identifier"
        case stagedBundleURL = "stagedBundleURL"
        case container = "container"
        case uniqueID = "uniqueID"
        case teamID = "teamID"
    }
}

struct ExtensionsPropertyList: Decodable {
    var version: Int?
    var extensions: Array<ExtensionData>
    var developerMode: Bool?
    var extensionsPolicy: [String]?
    var bootUUID: String?
    
    private enum CodingKeys: String, CodingKey {
        case version = "version"
        case extensions = "extensions"
        case developerMode = "developerMode"
        case extensionsPolicy = "extensionsPolicy"
        case bootUUID = "bootUUID"
    }
}
