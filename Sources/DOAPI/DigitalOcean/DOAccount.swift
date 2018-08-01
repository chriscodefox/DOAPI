//
//  DOAccount.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOAccount: Codable {
    
    public enum Status: String, Codable {
        case active
        case warning
        case locked
    }
    
    public var dropletLimit: Int
    public var floatingIPLimit: Int
    public var email: String
    public var uuid: String
    public var emailVerified: Bool
    public var status: Status
    public var statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case dropletLimit = "droplet_limit"
        case floatingIPLimit = "floating_ip_limit"
        case email
        case uuid
        case emailVerified = "email_verified"
        case status
        case statusMessage = "status_message"
    }
    
    public struct Get: DORequest {
        
        public struct Response: DOResponse {
            public let account: DOAccount
        }
        
        public let method = "GET"
        public let path = "account"
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
}
