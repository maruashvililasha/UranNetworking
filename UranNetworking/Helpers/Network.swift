//
//  Network.swift
//  UranNetworking
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import Foundation

class Network {
    static let timeOutInterval : Double = 10
    // Building URL
    static var urlBuilder = URLComponents()
    static let https = "https"
    static let host = "api.unsplash.com"
    
    static let apiKey = "4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"

    static var apiUrl: URLComponents {
        urlBuilder.scheme = https
        urlBuilder.host = host
        return urlBuilder
    }
    
    static var headers: [String: String] {
        return ["Authorization": "Client-ID \(apiKey)"]
    }
}
