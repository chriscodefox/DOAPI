//
//  DOSnapshot.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOSnapshot: Codable {
    
    public enum SnapshotType: String, Codable {
        case droplet
        case volume
    }
    
    public var id: Int
    public var name: String
    public var createdAt: Date
    public var regions: [String]
    public var resourceId: Int
    public var resourceType: SnapshotType
    public var minDiskInGiB: Int
    // NOTE: Discrepancy - documented as integer, returned as fractional
    public var sizeInGiB: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case createdAt = "created_at"
        case regions
        case resourceId = "resource_id"
        case resourceType = "resource_type"
        case minDiskInGiB = "min_disk_size"
        case sizeInGiB = "size_gigabytes"
    }
    
    public struct List: DORequest {
        
        public var type: SnapshotType?
        
        public struct Response: DOResponse {
            public let snapshots: [DOSnapshot]
        }
        
        public let method = "GET"
        public let path = "snapshots"
        public var query: [String : String]? {
            var items: [String: String] = [:]
            if let type = type {
                items["resource_type"] = "\(type)"
                
            }
            return items.isEmpty ? nil : items
        }
        public let body: DONull? = nil
        
        public init(type: SnapshotType?) {
            self.type = type
        }
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let snapshot: DOSnapshot
        }
        
        public let method = "GET"
        public var path: String { return "snapshots/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct Delete: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "snapshots/\(id)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
}
