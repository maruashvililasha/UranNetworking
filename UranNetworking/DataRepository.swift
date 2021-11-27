//
//  DataRepository.swift
//  UranNetworking
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import Foundation

/// Object for getting Data from remote server
public let dataRepo : DataRepoInterface = DataRepository()

public protocol DataRepoInterface {
    func getImages(page: Int, countPerPage: Int, sortBy: SortBy, completion: @escaping(Result<[UGImage],UGError>) -> Void)
    func searchImages(page: Int, countPerPage: Int, query: String, completion: @escaping(Result<[UGImage],UGError>) -> Void)
}

public enum SortBy: String {
    case latest = "latest"
    case oldest = "oldest"
    case popular = "popular"
}

class DataRepository : DataRepoInterface {
    
    var requests = Set<NSObject>()
    
    /// Get images from unsplash.com
    func getImages(page: Int, countPerPage: Int, sortBy: SortBy, completion: @escaping(Result<[UGImage],UGError>) -> Void) {
        
        let path = "/photos/"
        
        // parameters
        var params = [URLQueryItem]()
        params.append(URLQueryItem(name: "page", value: "\(page)"))
        params.append(URLQueryItem(name: "per_page", value: "\(countPerPage)"))
        params.append(URLQueryItem(name: "sort_by", value: sortBy.rawValue))
        
        let networking = Networking<[UGImage]>.shared
        networking.sendRequest(path: path, requestMethod: .get, params: params) { [weak self] error in
            completion(.failure(error))
            self?.requests.remove(networking)
        } response: { [weak self] response in
            completion(.success(response))
            self?.requests.remove(networking)
        }
        self.requests.insert(networking)
    }
    
    /// Search for images from unsplash.com
    func searchImages(page: Int, countPerPage: Int, query: String, completion: @escaping(Result<[UGImage],UGError>) -> Void) {
       
        let path = "/search/photos/"
        
        // parameters
        var params = [URLQueryItem]()
        params.append(URLQueryItem(name: "page", value: "\(page)"))
        params.append(URLQueryItem(name: "per_page", value: "\(countPerPage)"))
        params.append(URLQueryItem(name: "query", value: query))
        
        let networking = Networking<[UGImage]>.shared
        networking.sendRequest(path: path, requestMethod: .get, params: params) { [weak self] error in
            completion(.failure(error))
            self?.requests.remove(networking)
        } response: { [weak self] response in
            completion(.success(response))
            self?.requests.remove(networking)
        }
        self.requests.insert(networking)
    }
}

