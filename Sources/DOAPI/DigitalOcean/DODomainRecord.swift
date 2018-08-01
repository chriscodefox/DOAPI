//
//  DODomainRecord.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DODomainRecord: Codable {
    
    public enum RecordType: String, Codable {
        case addressIPV4 = "A"
        case addressIPV6 = "AAAA"
        case certificateAuthorityAuthorization = "CAA"
        case canonicalName = "CNAME"
        //case hostInformation = "HINFO"
        //case integratedServicesDigitalNetwork = "ISDN"
        case mailExchanger = "MX"
        case nameServer = "NS"
        //case reverseLookupPointer = "PTR"
        //case startOfAuthority = "SOA"
        case text = "TXT"
        case services = "SRV"
    }
    
    public enum Tag: String, Codable {
        case issue
        case issueWild = "issuewild"
        case iodef
    }
    
    public var id: Int
    public var type: RecordType
    // NOTE: Host name pattern - e.g., *.host.com
    public var name: String
    public var data: String
    public var priority: Int?
    public var port: Int?
    public var ttl: Int
    public var weight: Int?
    public var flags: UInt
    public var tag: Tag
    
    // NOTE: CodingKeys autogenerates properly
    
    public struct Headless: Codable {
        public var type: RecordType
        public var name: String
        public var data: String
        public var priority: Int?
        public var port: Int?
        public var ttl: Int
        public var weight: Int?
        public var flags: UInt
        public var tag: Tag
    }
    
    public var headless: Headless {
        return Headless(
            type: type,
            name: name,
            data: data,
            priority: priority,
            port: port,
            ttl: ttl,
            weight: weight,
            flags: flags,
            tag: tag
        )
    }
    
    public struct List: DORequest {
        
        public var name: String
        
        public struct Response: DOResponse {
            public let domainRecords: [DODomainRecord]
            enum CodingKeys: String, CodingKey {
                case domainRecords = "domain_records"
            }
        }
        
        public let method = "GET"
        public var path: String { return "domains/\(name)/records" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(name: String) {
            self.name = name
        }
    }
    
    public struct Create: DORequest {
        
        public typealias Body = DODomainRecord.Headless
        
        // NOTE: Domain name - e.g., host.com
        public var name: String
        public var record: DODomainRecord.Headless
        
        public struct Response: DOResponse {
            public let domainRecord: DODomainRecord
            enum CodingKeys: String, CodingKey {
                case domainRecord = "domain_record"
            }
        }
        
        public let method = "POST"
        public var path: String { return "domains/\(name)/records" }
        public let query: [String : String]? = nil
        public var body: Body? { return record }
        
        public init(name: String, record: DODomainRecord.Headless) {
            self.name = name
            self.record = record
        }
        
    }
    
    public struct Get: DORequest {
        
        public var name: String
        public var recordId: Int
        
        public struct Response: DOResponse {
            public let domainRecord: DODomainRecord
            enum CodingKeys: String, CodingKey {
                case domainRecord = "domain_record"
            }
        }
        
        public let method = "GET"
        public var path: String { return "domains/\(name)/records/\(recordId)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(name: String, recordId: Int) {
            self.name = name
            self.recordId = recordId
        }
    }
    
    // NOTE: Easy mode - we do not allow partial updates
    public struct Update: DORequest, Encodable {
        
        public typealias Body = DODomainRecord.Headless
        
        // NOTE: Domain name - e.g., host.com
        public var name: String
        public var record: DODomainRecord
        
        public struct Response: DOResponse {
            public let domainRecord: DODomainRecord
            enum CodingKeys: String, CodingKey {
                case domainRecord = "domain_record"
            }
        }
        
        public let method = "PUT"
        public var path: String { return "domains/\(name)/records/\(record.id)" }
        public let query: [String : String]? = nil
        public var body: Body? { return record.headless }
        
        public init(name: String, record: DODomainRecord) {
            self.name = name
            self.record = record
        }
        
    }
    
    
    public struct Delete: DORequest {
        
        public var name: String
        public var recordId: Int
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "domains/\(name)/records/\(recordId)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(name: String, recordId: Int) {
            self.name = name
            self.recordId = recordId
        }
        
    }
}
