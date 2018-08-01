//
//  DORegion.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DORegion: Codable {
    
    public var slug: String
    public var name: String
    public var sizes: [String]
    public var available: Bool
    public var features: [String]
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let regions: [DORegion]
        }
        
        public let method = "GET"
        public var path: String { return "regions" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
}
