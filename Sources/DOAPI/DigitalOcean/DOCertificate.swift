//
//  DOCertificate.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOCertificate: Codable {
    
    public enum State: String, Codable {
        case pending
        case verified
        case error
    }
    
    public enum CertificateType: String, Codable {
        case custom
        case letsEncrypt = "lets_encrypt"
    }
    
    public var id: Int
    public var name: String
    public var notAfter: Date
    public var sha1Fingerprint: String
    public var createdAt: Date
    public var dnsNames: [String]// TODO: Make proper domain object
    public var state: State
    public var type: CertificateType
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case notAfter = "not_after"
        case sha1Fingerprint = "sha1_fingerprint"
        case createdAt = "created_at"
        case dnsNames = "dns_names"
        case state
        case type
    }
    
    public struct Create: DORequest, Encodable {
        
        public typealias Body = Create
        
        public var name: String
        public var type: CertificateType
        
        public var privateKey: String? // Required for custom
        public var leafCertificate: String?    // Required for custom
        public var certificateChain: String?   // Optional for custom
        
        public var dnsNames: [String]? // Required for letsEncrypt
        
        enum CodingKeys: String, CodingKey {
            case name
            case type
            case privateKey = "private_key"
            case leafCertificate = "leaf_certificate"
            case certificateChain = "certificate_chain"
            case dnsNames = "dns_names"
        }
        
        public struct Response: DOResponse {
            public let certificate: DOCertificate
        }
        
        public let method = "POST"
        public let path = "certificates"
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(letsEncrypt name: String, dnsNames: [String]) {
            self.name = name
            self.type = .letsEncrypt
            self.privateKey = nil
            self.leafCertificate = nil
            self.certificateChain = nil
            self.dnsNames = dnsNames
        }
        
        public init(custom name: String, privateKey: String, leafCertificate: String, certificateChain: String? = nil) {
            self.name = name
            self.type = .custom
            self.privateKey = privateKey
            self.leafCertificate = leafCertificate
            self.certificateChain = certificateChain
            self.dnsNames = nil
        }
        
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let certificate: DOCertificate
        }
        
        public let method = "GET"
        public var path: String { return "certificates/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let certificates: [DOCertificate]
        }
        
        public let method = "GET"
        public let path = "certificates"
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
    public struct Delete: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "certificates/\(id)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
}
