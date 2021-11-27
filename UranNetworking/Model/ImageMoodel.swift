//
//  ImageMoodel.swift
//  UranNetworking
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import Foundation

public struct UGImage: Codable {
    public let urls: ImageUrls
    
    enum CodingKeys: String, CodingKey {
        case urls
    }
}

// MARK: - Urls
public struct ImageUrls: Codable {
    public let raw, full, regular, small: String
    public let thumb: String
}
