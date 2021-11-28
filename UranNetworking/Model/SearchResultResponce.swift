//
//  SearchResultResponce.swift
//  UranNetworking
//
//  Created by Lasha Maruashvili on 28.11.21.
//

import Foundation

struct GetSearchImagesResponse: Codable {
    let total, totalPages: Int
    let results: [UGImage]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
