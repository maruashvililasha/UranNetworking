//
//  Networking.swift
//  UranNetworking
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import Foundation
import Combine

class Networking<Model> : NSObject, URLSessionTaskDelegate where Model:Codable {
    
    private var subscribers : Set<AnyCancellable>
    
    typealias ResponseClosure = (Model) -> Void
    typealias ErrorClosure = (UGError) -> Void
    
    static var shared: Networking<Model> {
        return Networking<Model>()
    }
    
    public override init() {
        self.subscribers = Set<AnyCancellable>()
        print("==Init== Networking, with type: ", Model.self)
    }
    
    deinit {
        print("==Deinit== Networking, with type: ", Model.self)
    }
    
    func sendRequest(path: String, requestMethod: RequestMethod, params: [URLQueryItem], error: @escaping(ErrorClosure), response: @escaping(ResponseClosure)) {
        
        var urlBuilder = Network.apiUrl
        urlBuilder.path = path
        
        urlBuilder.queryItems = params
        
        guard let url = urlBuilder.url else {
            fatalError("Problem Generating URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestMethod.rawValue
        
        // HTTP Headers
        request.allHTTPHeaderFields = Network.headers
        
        request.timeoutInterval = Network.timeOutInterval
        
        let session = URLSession(configuration: .default)
        session
            .dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap { data, _ in
//                print("JSON String: \(String(data: data, encoding: .utf8))")
                return try JSONDecoder().decode(Model.self, from: data)
            }.sink { completions in
                if case .failure(let err) = completions {
                    if (err as? URLError)?.code == .timedOut {
                        //Should Check Network Connection
                        let err = UGError(errorType: .toBeShown, errorMessage: "Can't connect to server")
                        error(err)
                        print(err)
                    } else if (err as? Swift.DecodingError) != nil {
                        let err = UGError(errorType: .toBeShown, errorMessage: "Can't parse data")
                        error(err)
                        print(err)
                    }
                    let err = UGError(errorType: .toBeShown, errorMessage: err.localizedDescription)
                    error(err)
                    print(err)
                }
            } receiveValue: { decodedResponce in
                response(decodedResponce)
            }.store(in: &self.subscribers)
    }
}
