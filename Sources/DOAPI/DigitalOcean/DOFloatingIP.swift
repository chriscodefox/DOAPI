//
//  DOFloatingIP.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOFloatingIP: Codable {
    
    public var ip: String
    public var region: DORegion
    public var droplet: DODroplet?
    
}
