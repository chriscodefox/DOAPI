//
//  DOVolumeAction.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/28/18.
//

import Foundation

public struct DOVolumeAction: Codable {
    
    public enum Status: String, Codable {
        case inProgress = "in-progress"
        case completed
        case errored
    }
    
    public enum ActionType: String, Codable {
        case attachVolume = "attach_volume"
        case detachVolume = "detach_volume"
        case resize
    }
    
    public var id: Int
    public var status: Status
    public var type: ActionType
    public var startedAt: Date
    public var completedAt: Date
    public var resourceId: Int?
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
    
    public struct Attach: DORequest, Encodable {
        
        public typealias Body = Attach
        
        public var id: Int
        
        let type: String = "attach"
        public var dropletId: Int
        public var region: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case dropletId = "droplet_id"
            case region
        }
        
        public struct Response: DOResponse {
            public let action: DOVolumeAction
        }
        
        public let method = "POST"
        public var path: String { return "volumes/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, dropletId: Int, region: String) {
            self.id = id
            self.dropletId = dropletId
            self.region = region
        }
        
    }
    
    public struct AttachByName: DORequest, Encodable {
        
        public typealias Body = AttachByName
        
        public var id: Int
        
        let type: String = "attach"
        public var dropletId: Int
        public var region: String
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case dropletId = "droplet_id"
            case region
            case name
        }
        
        public struct Response: DOResponse {
            public let action: DOVolumeAction
        }
        
        public let method = "POST"
        public let path = "volumes/actions"
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, dropletId: Int, region: String, name: String) {
            self.id = id
            self.dropletId = dropletId
            self.region = region
            self.name = name
        }
        
    }
    
    public struct Detach: DORequest, Encodable {
        
        public typealias Body = Detach
        
        public var id: Int
        
        let type: String = "detach"
        public var dropletId: Int
        public var region: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case dropletId = "droplet_id"
            case region
        }
        
        public struct Response: DOResponse {
            public let action: DOVolumeAction
        }
        
        public let method = "POST"
        public var path: String { return "volumes/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, dropletId: Int, region: String) {
            self.id = id
            self.dropletId = dropletId
            self.region = region
        }
        
    }
    
    public struct DetachByName: DORequest, Encodable {
        
        public typealias Body = DetachByName
        
        public var id: Int
        
        let type: String = "detach"
        public var dropletId: Int
        public var region: String
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case dropletId = "droplet_id"
            case region
            case name
        }
        
        public struct Response: DOResponse {
            public let action: DOVolumeAction
        }
        
        public let method = "POST"
        public let path = "volumes/actions"
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, dropletId: Int, region: String, name: String) {
            self.id = id
            self.dropletId = dropletId
            self.region = region
            self.name = name
        }
        
    }
    
    public struct Resize: DORequest, Encodable {
        
        public typealias Body = Resize
        
        public var id: Int
        
        let type: String = "detach"
        public var sizeInGiB: Double
        public var region: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case sizeInGiB = "size_gigabytes"
            case region
        }
        
        public struct Response: DOResponse {
            public let action: DOVolumeAction
        }
        
        public let method = "POST"
        public var path: String { return "volumes/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, sizeInGiB: Double, region: String) {
            self.id = id
            self.sizeInGiB = sizeInGiB
            self.region = region
        }
    }
    
    public struct List: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let actions: [DOVolumeAction]
        }
        
        public let method = "GET"
        public var path: String { return "volumes/\(id)/actions" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        public var actionId: Int
        
        public struct Response: DOResponse {
            public let action: DOVolumeAction
        }
        
        public let method = "GET"
        public var path: String { return "volumes/\(id)/actions/\(actionId)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int, actionId: Int) {
            self.id = id
            self.actionId = actionId
        }
    }
    
}
