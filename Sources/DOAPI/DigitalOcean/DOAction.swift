//
//  DOAction.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOAction: Codable {
    
    public enum Status: String, Codable {
        case inProgress = "in-progress"
        case completed
        case errored
    }
    
    public var id: Int
    public var status: Status
    public var type: String
    
    public var startedAt: Date
    public var completedAt: Date
    
    public var resourceId: Int
    public var resourceType: String
    
    public var region: DORegion
    public var regionSlug: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case type
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case resourceId = "resource_id"
        case resourceType = "resource_type"
        case region
        case regionSlug = "region_slug"
    }
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let actions: [DOAction]
        }
        
        public let method = "GET"
        public let path = "actions"
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let action: DOAction
        }
        
        public let method = "GET"
        public var path: String { return "actions/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
}

/*
 
protocol DOResourceType: RawRepresentable, Codable {
    var rawValue: String { get }
    var resourceType: String { return rawValue }
    init(resourceType: String)
}

protocol DOActionable {
    associatedtype ActionType: D
    var resourceType: String { get }
    var singular: String { get }
    var plural: String { get }
    var basePath: String { get }
    func path(for id: Int) -> String
    func subpath(_ subpath: String, for id: Int) -> String
}

extension DOActionable {
 
    func path(for id: Int) -> String {
        return "\(basePath)/\(id)"
    }
 
    func subpath(_ subpath: String, for id: Int) -> String {
        return "\(path(for: id))/\(subpath)"
    }
 
}

protocol DOActionResource: Codable {
    var resourceType: String { get }
}

extension String: DOActionResource {
    var resourceType: String { return self }
}

struct DOActionG<T: DOActionable> {
 
    enum Status: String, Codable {
        case inProgress = "in-progress"
        case completed
        case errored
    }
 
    var id: Int
    var status: Status
    var type: T
 
    var startedAt: Date
    var completedAt: Date
 
    var resourceId: Int
    var resourceType: T
 
    var region: DORegion
    var regionSlug: String?
 
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case type
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case resourceId = "resource_id"
        case resourceType = "resource_type"
        case region
        case regionSlug = "region_slug"
    }
 
}
 */
