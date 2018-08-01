//
//  DOSize.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOSize: Codable {
    
    public var slug: String
    
    public var available: Bool
    
    public var memoryInMiB: Int
    public var virtualCPUs: Int
    public var diskInGiB: Int
    // NOTE: Discrepancy - described as integer, returned as fractional
    public var transferBandwidthInTiB: Double
    
    public var regions: [String]
    
    // NOTE: Discrepancy x2 - described as integer, returned as fractional
    public var priceMonthly: Double
    public var priceHourly: Double
    
    enum CodingKeys: String, CodingKey {
        
        case slug
        
        case available
        
        case memoryInMiB = "memory"
        case virtualCPUs = "vcpus"
        case diskInGiB = "disk"
        case transferBandwidthInTiB = "transfer"
        
        case regions
        
        case priceMonthly = "price_monthly"
        case priceHourly = "price_hourly"
    }
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let sizes: [DOSize]
        }
        
        public let method = "GET"
        public var path: String { return "sizes" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
}
