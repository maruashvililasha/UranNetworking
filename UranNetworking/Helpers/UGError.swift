//
//  UGError.swift
//  UranNetworking
//
//  Created by Lasha Maruashvili on 26.11.21.
//

import Foundation

public enum ErrorType: Int {
    case couldBeRejected = 0
    case toBeShown = 1
    case shouldTerminateApp = 2
    case other = 3
}

public struct UGError : Error {
    public var errorCode : Int?
    public var errorType : ErrorType
    public var errorMessage : String
    public var endPoint : String?
    
    public init(errorType: ErrorType, errorMessage: String = "Unexpected Error", endpoint: String? = nil) {
        self.errorType = errorType
        self.errorMessage = errorMessage
        self.endPoint = endpoint
    }
}

extension UGError: CustomDebugStringConvertible {
    public var debugDescription: String {
        var codeForDebug = "nil"
        if let code = errorCode {
            codeForDebug = "\(code)"
        }
        return "\n!!!!!!!! - Error \nError Type : \(self.errorType) \nError Message: \(self.errorMessage)\nEndpoint: \(self.endPoint ?? "n/a")\nError Code: \(codeForDebug)\n!!!!!!!! - End\n"
    }
}
