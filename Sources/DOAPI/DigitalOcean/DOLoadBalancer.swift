//
//  DOLoadBalancer.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOLoadBalancer: Codable {
    
    public enum Algorithm: String, Codable {
        case roundRobin = "round_robin"
        case leastConnections = "least_connection"
    }
    
    public enum Status: String, Codable {
        case new
        case active
        case errored
    }
    
    public enum ForwardingConnectionProtocol: String, Codable {
        case http
        case https
        case http2
        case tcp
    }
    
    public struct ForwardingRules: Codable {
        
        public var entryConnection: ForwardingConnectionProtocol
        public var entryPort: Int
        public var targetConnection: ForwardingConnectionProtocol
        public var targetPort: Int
        public var certificateId: String
        public var tlsPassthrough: Bool
        
        enum CodingKeys: String, CodingKey {
            case entryConnection = "entry_protocol"
            case entryPort = "entry_port"
            case targetConnection = "target_protocol"
            case targetPort = "target_port"
            case certificateId = "certificate_id"
            case tlsPassthrough = "tls_passthrough"
        }
        
        public init(entryConnection: ForwardingConnectionProtocol, entryPort: Int, targetConnection: ForwardingConnectionProtocol, targetPort: Int, certificateId: String, tlsPassthrough: Bool) {
            self.entryConnection = entryConnection
            self.entryPort = entryPort
            self.targetConnection = targetConnection
            self.targetPort = targetPort
            self.certificateId = certificateId
            self.tlsPassthrough = tlsPassthrough
        }
    }
    
    public enum HealthConnectionProtocol: String, Codable {
        case http
        case tcp
    }
    
    public struct HealthCheck: Codable {
        
        public var connection: HealthConnectionProtocol
        public var port: Int
        public var path: String
        public var checkIntervalInSeconds: Int
        public var responseTimeoutInSeconds: Int
        public var unhealthyThreshold: Int
        public var healthyThreshold: Int
        
        enum CodingKeys: String, CodingKey {
            case connection = "protocol"
            case port
            case path
            case checkIntervalInSeconds = "check_interval_seconds"
            case responseTimeoutInSeconds = "response_timeout_seconds"
            case unhealthyThreshold = "unhealthy_threshold"
            case healthyThreshold = "healthy_threshold"
        }
        
        public init(connection: HealthConnectionProtocol, port: Int, path: String, checkIntervalInSeconds: Int, responseTimeoutInSeconds: Int, unhealthyThreshold: Int, healthyThreshold: Int) {
            self.connection = connection
            self.port = port
            self.path = path
            self.checkIntervalInSeconds = checkIntervalInSeconds
            self.responseTimeoutInSeconds = responseTimeoutInSeconds
            self.unhealthyThreshold = unhealthyThreshold
            self.healthyThreshold = healthyThreshold
        }
    }
    
    public struct StickySessions: Codable {
        
        public enum SessionType: String, Codable {
            case none
            case cookies
        }
        
        public var type: SessionType
        public var cookieName: String?
        public var cookieTTL: String?
        
        enum CodingKeys: String, CodingKey {
            case type
            case cookieName = "cookie_name"
            case cookieTTL = "cookie_ttl_seconds"
        }
        
        public init(type: SessionType, cookieName: String?, cookieTTL: String?) {
            self.type = type
            self.cookieName = cookieName
            self.cookieTTL = cookieTTL
        }
        
    }
    
    public var id: Int
    public var name: String
    public var ip: String
    public var algorithm: Algorithm
    public var status: Status
    public var createdAt: Date
    public var forwardingRules: ForwardingRules
    public var healthCheck: HealthCheck
    public var stickySessions: StickySessions
    public var region: DORegion
    public var tag: String
    public var dropletIds: [Int]
    public var redirectHTTP: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ip
        case algorithm
        case status
        case createdAt = "created_at"
        case forwardingRules = "forwarding_rules"
        case healthCheck = "health_check"
        case stickySessions = "sticky_sessions"
        case region
        case tag
        case dropletIds = "droplet_ids"
        case redirectHTTP = "redirect_http_to_https"
    }
    
    public struct Headless: Encodable {
        
        public var name: String
        public var algorithm: Algorithm
        public var region: String
        public var forwardingRules: ForwardingRules
        public var healthCheck: HealthCheck
        public var stickySessions: StickySessions
        public var redirectHTTP: Bool
        
        // One of these two must be supplied
        public var tag: String?
        public var dropletIds: [Int]?
        
        enum CodingKeys: String, CodingKey {
            case name
            case algorithm
            case region
            case forwardingRules = "forwarding_rules"
            case healthCheck = "health_check"
            case stickySessions = "sticky_sessions"
            case redirectHTTP = "redirect_http_to_https"
            case tag
            case dropletIds = "droplet_ids"
        }
        
        public init(name: String, algorithm: Algorithm, region: String, forwardingRules: ForwardingRules, healthCheck: HealthCheck, stickySessions: StickySessions, redirectHTTP: Bool, tag: String? = nil) {
            self.name = name
            self.algorithm = algorithm
            self.region = region
            self.forwardingRules = forwardingRules
            self.healthCheck = healthCheck
            self.stickySessions = stickySessions
            self.redirectHTTP = redirectHTTP
            self.tag = tag
        }
        
        public init(name: String, algorithm: Algorithm, region: String, forwardingRules: ForwardingRules, healthCheck: HealthCheck, stickySessions: StickySessions, redirectHTTP: Bool, dropletIds: [Int]) {
            self.name = name
            self.algorithm = algorithm
            self.region = region
            self.forwardingRules = forwardingRules
            self.healthCheck = healthCheck
            self.stickySessions = stickySessions
            self.redirectHTTP = redirectHTTP
            self.dropletIds = dropletIds
        }
    }
    
    public var headless: Headless {
        return Headless(
            name: name,
            algorithm: algorithm,
            region: region.slug,
            forwardingRules: forwardingRules,
            healthCheck: healthCheck,
            stickySessions: stickySessions,
            redirectHTTP: redirectHTTP,
            dropletIds: [id])
    }
    
    public struct Create: DORequest {
        
        public typealias Body = DOLoadBalancer.Headless
        
        public var loadBalancer: DOLoadBalancer.Headless
        
        public struct Response: DOResponse {
            public let loadBalancer: DOLoadBalancer
            enum CodingKeys: String, CodingKey {
                case loadBalancer = "load_balancer"
            }
        }
        
        public let method = "POST"
        public var path: String { return "load_balancers" }
        public let query: [String : String]? = nil
        public var body: Body? { return loadBalancer }
        
        public init(loadBalancer: DOLoadBalancer.Headless) {
            self.loadBalancer = loadBalancer
        }
        
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let loadBalancer: DOLoadBalancer
            enum CodingKeys: String, CodingKey {
                case loadBalancer = "load_balancer"
            }
        }
        
        public let method = "GET"
        public var path: String { return "load_balancers/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let loadBalancers: [DOLoadBalancer]
            enum CodingKeys: String, CodingKey {
                case loadBalancers = "load_balancers"
            }
        }
        
        public let method = "GET"
        public var path: String { return "load_balancers" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
    public struct Update: DORequest {
        
        public typealias Body = DOLoadBalancer.Headless
        
        public var loadBalancer: DOLoadBalancer
        
        public struct Response: DOResponse {
            public let loadBalancer: DOLoadBalancer
            enum CodingKeys: String, CodingKey {
                case loadBalancer = "load_balancer"
            }
        }
        
        public let method = "PUT"
        public var path: String { return "load_balancers/\(loadBalancer.id)" }
        public let query: [String : String]? = nil
        public var body: Body? { return loadBalancer.headless }
        
        public init(loadBalancer: DOLoadBalancer) {
            self.loadBalancer = loadBalancer
        }
        
    }
    
    public struct Delete: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "load_balancers/\(id)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    
    public struct AddDroplets: DORequest, Encodable {
        
        public var id: Int
        public var dropletIds: [Int]
        
        enum CodingKeys: String, CodingKey {
            case dropletIds = "droplet_ids"
        }
        
        public struct Response: DOResponse { }
        
        public let method = "POST"
        public var path: String { return "load_balancers/\(id)/droplets" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int, dropletIds: [Int]) {
            self.id = id
            self.dropletIds = dropletIds
        }
        
    }
    
    
    public struct RemoveDroplets: DORequest, Encodable {
        
        public var id: Int
        public var dropletIds: [Int]
        
        enum CodingKeys: String, CodingKey {
            case dropletIds = "droplet_ids"
        }
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "load_balancers/\(id)/droplets" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int, dropletIds: [Int]) {
            self.id = id
            self.dropletIds = dropletIds
        }
        
    }
    
    public struct AddForwardingRules: DORequest {
        
        public typealias Body = ForwardingRules
        
        public var id: Int
        public var forwardingRules: ForwardingRules
        
        enum CodingKeys: String, CodingKey {
            case forwardingRules = "forwarding_rules"
        }
        
        public struct Response: DOResponse { }
        
        public let method = "POST"
        public var path: String { return "load_balancers/\(id)/fowarding_rules" }
        public let query: [String : String]? = nil
        public var body: Body? { return forwardingRules }
        
        public init(id: Int, forwardingRules: ForwardingRules) {
            self.id = id
            self.forwardingRules = forwardingRules
        }
        
    }
    
    public struct RemoveForwardingRules: DORequest {
        
        public typealias Body = ForwardingRules
        
        public var id: Int
        public var forwardingRules: ForwardingRules
        
        enum CodingKeys: String, CodingKey {
            case forwardingRules = "forwarding_rules"
        }
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "load_balancers/\(id)/fowarding_rules" }
        public let query: [String : String]? = nil
        public var body: Body? { return forwardingRules }
        
        public init(id: Int, forwardingRules: ForwardingRules) {
            self.id = id
            self.forwardingRules = forwardingRules
        }
        
    }
    
}
