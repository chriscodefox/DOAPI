//
//  DODomain.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DODomain: Codable {
    
    public var name: String
    public var ttl: Int    // NOTE: Seconds
    // TODO: Figure out content format, make domain objects
    public var zoneFile: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case ttl
        case zoneFile = "zone_file"
    }
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let domains: [DODomain]
        }
        
        public let method = "GET"
        public let path = "domains"
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
    public struct Create: DORequest, Encodable {
        
        public typealias Body = Create
        
        public var name: String
        public var ipAddress: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case ipAddress = "ip_address"
        }
        
        public struct Response: DOResponse {
            public let domain: DODomain
        }
        
        public let method = "POST"
        public let path = "domains"
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(name: String, ipAddress: String? = nil) {
            self.name = name
            self.ipAddress = ipAddress
        }
        
    }
    
    public struct Get: DORequest {
        
        public var name: String
        
        public struct Response: DOResponse {
            public let domain: DODomain
        }
        
        public let method = "GET"
        public var path: String { return "domains/\(name)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(name: String) {
            self.name = name
        }
    }
    
    
    public struct Delete: DORequest {
        
        public var name: String
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "domains/\(name)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(name: String) {
            self.name = name
        }
        
    }
}
