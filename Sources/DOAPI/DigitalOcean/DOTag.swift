//
//  DOTag.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOTag: Codable {
    
    public struct Statistic<T: Codable>: Codable {
        
        public var count: Int
        public var lastTagged: T?
        
        enum CodingKeys: String, CodingKey {
            case count
            case lastTagged = "last_tagged"
        }
    }
    
    public struct Resources: Codable {
        public var droplets: Statistic<DODroplet>?
    }
    
    public var name: String
    public var resources: Resources
    
    public struct Create: DORequest, Encodable {
        
        public typealias Body = Create
        
        public var name: String
        
        public struct Response: DOResponse {
            public let tag: DOTag
        }
        
        public let method = "POST"
        public let path: String = "tags"
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(name: String) {
            self.name = name
        }
        
    }
    
    public struct Get: DORequest {
        
        public var name: String
        
        public struct Response: DOResponse {
            public let tag: DOTag
        }
        
        public let method = "GET"
        public var path: String { return "tags/\(name)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(name: String) {
            self.name = name
        }
    }
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let tags: [DOTag]
        }
        
        public let method = "GET"
        public let path = "tags"
        public let query: [String: String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
    public struct ResourceIdentifier: Codable {
        
        public var resourceId: String
        public var resourceType: String
        
        enum CodingKeys: String, CodingKey {
            case resourceId = "resource_id"
            case resourceType = "resource_type"
        }
        
        public init(resourceId: String, resourceType: String) {
            self.resourceId = resourceId
            self.resourceType = resourceType
        }
    }
    
    public struct TagResources: DORequest {
        
        public var name: String
        
        public var resources: [ResourceIdentifier]
        
        enum CodingKeys: String, CodingKey {
            case resources
        }
        
        public struct Response: DOResponse { }
        
        public let method = "POST"
        public var path: String { return "tags/\(name)/resources" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(name: String, resources: [ResourceIdentifier]) {
            self.name = name
            self.resources = resources
        }
        
    }
    
    public struct UntagResources: DORequest {
        
        public var name: String
        
        public var resources: [ResourceIdentifier]
        
        enum CodingKeys: String, CodingKey {
            case resources
        }
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "tags/\(name)/resources" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(name: String, resources: [ResourceIdentifier]) {
            self.name = name
            self.resources = resources
        }
        
    }
    
}
