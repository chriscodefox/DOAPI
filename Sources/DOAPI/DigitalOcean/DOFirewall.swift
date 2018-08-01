//
//  DOFirewall.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOFirewall: Codable {
    
    public enum Status: String, Codable {
        case waiting
        case succeeded
        case failed
    }
    
    public struct PendingChange: Codable {
        var dropletId: Int
        var removing: Bool // ???
        var status: Status
    }
    
    public enum ConnectionProtocol: String, Codable {
        case tcp
        case udp
        case icmp
    }
    
    // NOTE: Discrepancy
    //  Ports can be returned as a string as described, but also as an unquoted integer
    //  This may cause problems
    public enum PortRange: RawRepresentable, Codable {
        
        case single(Int)
        case range(from: Int, to: Int)
        case all
        
        public var rawValue: String {
            switch self {
            case let .single(port):
                return "\(port)"
            case let .range(from,to):
                return "\(from)-\(to)"
            case .all:
                return "all"
            }
        }
        
        public init?(rawValue: String) {
            if rawValue == "all" {
                self = .all
                return
            }
            let decimals = CharacterSet.decimalDigits
            let decimalsAndDash = decimals.union(CharacterSet(charactersIn: "-"))
            if rawValue.contains(only: decimals) {
                self = .single(Int(rawValue)!)
                return
            }
            if rawValue.contains(only: decimalsAndDash) {
                let chunks = rawValue.split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false).map { String($0) }
                guard chunks.count == 2 else { return nil }
                let from = chunks[0]
                let to = chunks[1]
                guard !from.isEmpty, from.contains(only: decimals), !to.isEmpty, to.contains(only: decimals) else { return nil }
                let fromI = Int(from)!
                let toI = Int(to)!
                guard fromI < toI else { return nil }
                self = .range(from: fromI, to: toI)
                return
            }
            return nil
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(RawValue.self)
            guard let this = PortRange(rawValue: rawValue) else {
                throw DOError.badFormatPortRange(rawValue)
            }
            self = this
        }
        
        public func encode(to encoder: Encoder) throws {
            try rawValue.encode(to: encoder)
        }
    }
    
    public struct RuleTargets: Codable {
        
        public var addresses: [String]
        public var dropletIds: [Int]
        public var loadBalancerIds: [Int]
        public var tags: [String]
        
        enum CodingKeys: String, CodingKey {
            case addresses
            case dropletIds = "droplet_ids"
            case loadBalancerIds = "load_balancer_ids"
            case tags
        }
        
        public init(addresses: [String], dropletIds: [Int], loadBalancerIds: [Int], tags: [String]) {
            self.addresses = addresses
            self.dropletIds = dropletIds
            self.loadBalancerIds = loadBalancerIds
            self.tags = tags
        }
    }
    
    public struct InboundRule: Codable {
        
        public var connection: ConnectionProtocol
        public var ports: PortRange
        public var sources: RuleTargets
        
        enum CodingKeys: String, CodingKey {
            case connection = "protocol"
            case ports
            case sources
        }
        
        public init(connection: ConnectionProtocol, ports: PortRange, sources: RuleTargets) {
            self.connection = connection
            self.ports = ports
            self.sources = sources
        }
    }
    
    public struct OutboundRule: Codable {
        
        public var connection: ConnectionProtocol
        public var ports: PortRange
        public var destinations: RuleTargets
        
        enum CodingKeys: String, CodingKey {
            case connection = "protocol"
            case ports
            case destinations
        }
        
        public init(connection: ConnectionProtocol, ports: PortRange, destinations: RuleTargets) {
            self.connection = connection
            self.ports = ports
            self.destinations = destinations
        }
    }
    
    public struct Headless: Codable {
        
        public var name: String
        public var inboundRules: [InboundRule]
        public var outboundRules: [OutboundRule]
        public var dropletIds: [Int]
        public var tags: [String]
        
        enum CodingKeys: String, CodingKey {
            case name
            case inboundRules = "inbound_rules"
            case outboundRules = "outbound_rules"
            case dropletIds = "droplet_ids"
            case tags
        }
        
        public init(name: String, inboundRules: [InboundRule], outboundRules: [OutboundRule], dropletIds: [Int], tags: [String]) {
            self.name = name
            self.inboundRules = inboundRules
            self.outboundRules = outboundRules
            self.dropletIds = dropletIds
            self.tags = tags
        }
        
    }
    
    public var headless: Headless {
        return Headless(
            name: name,
            inboundRules: inboundRules,
            outboundRules: outboundRules,
            dropletIds: dropletIds,
            tags: tags)
    }
    
    public var id: Int
    public var name: String
    public var status: Status
    public var createdAt: Date
    public var pendingChanges: [PendingChange]
    public var inboundRules: [InboundRule]
    public var outboundRules: [OutboundRule]
    public var dropletIds: [Int]
    public var tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case createdAt = "created_at"
        case pendingChanges = "pending_changes"
        case inboundRules = "inbound_rules"
        case outboundRules = "outbound_rules"
        case dropletIds = "droplet_ids"
        case tags
    }
    
    public struct Create: DORequest {
        
        public typealias Body = DOFirewall.Headless
        
        public var firewall: DOFirewall.Headless
        
        public struct Response: DOResponse {
            public let firewall: DOFirewall
        }
        
        public let method = "POST"
        public var path: String { return "firewalls" }
        public let query: [String : String]? = nil
        public var body: Body? { return firewall }
        
        public init(firewall: DOFirewall.Headless) {
            self.firewall = firewall
        }
        
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        public var name: String
        
        public struct Response: DOResponse {
            public let firewall: DOFirewall
        }
        
        public let method = "GET"
        public var path: String { return "firewalls/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let firewalls: [DOFirewall]
        }
        
        public let method = "GET"
        public var path: String { return "firewalls" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
    public struct Update: DORequest {
        
        public typealias Body = DOFirewall.Headless
        
        public var firewall: DOFirewall
        
        public struct Response: DOResponse {
            public let firewall: DOFirewall
        }
        
        public let method = "PUT"
        public var path: String { return "firewalls/\(firewall.id)" }
        public let query: [String : String]? = nil
        public var body: Body? { return firewall.headless }
        
        public init(firewall: DOFirewall) {
            self.firewall = firewall
        }
        
    }
    
    public struct Delete: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "firewalls/\(id)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct AddTags: DORequest, Encodable {
        
        public var id: Int
        public var tags: [String]
        
        enum CodingKeys: String, CodingKey {
            case tags
        }
        
        public struct Response: DOResponse { }
        
        public let method = "POST"
        public var path: String { return "firewalls/\(id)/tags" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int, tags: [String]) {
            self.id = id
            self.tags = tags
        }

    }
    
    public struct RemoveTags: DORequest, Encodable {
        
        public var id: Int
        public var tags: [String]
        
        enum CodingKeys: String, CodingKey {
            case tags
        }
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "firewalls/\(id)/tags" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int, tags: [String]) {
            self.id = id
            self.tags = tags
        }
        
    }
    
    public struct RuleSet: Encodable {
        
        var inboundRules: [InboundRule]
        var outboundRules: [OutboundRule]
        
        public init(inboundRules: [InboundRule], outboundRules: [OutboundRule]) {
            self.inboundRules = inboundRules
            self.outboundRules = outboundRules
        }
    }
    
    public struct AddRules: DORequest {
        
        public typealias Body = RuleSet
        
        public var id: Int
        public var ruleSet: RuleSet
        
        public struct Response: DOResponse { }
        
        public let method = "POST"
        public var path: String { return "firewalls/\(id)/rules" }
        public let query: [String : String]? = nil
        public var body: RuleSet? { return ruleSet }
        
        public init(id: Int, ruleSet: RuleSet) {
            self.id = id
            self.ruleSet = ruleSet
        }
        
    }
    
    public struct RemoveRules: DORequest {
        
        public typealias Body = RuleSet
        
        public var id: Int
        public var ruleSet: RuleSet
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "firewalls/\(id)/rules" }
        public let query: [String : String]? = nil
        public var body: RuleSet? { return ruleSet }
        
        public init(id: Int, ruleSet: RuleSet) {
            self.id = id
            self.ruleSet = ruleSet
        }
        
    }
}
