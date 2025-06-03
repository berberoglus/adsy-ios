//
//  HTTPClientError+LocalizedDescription.swift
//  Adsy
//
//  Created by Samet Berberoğlu on 2025-06-03.
//

import Foundation
import SBNetworking

extension HTTPClientError: @retroactive LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL format or construction"
        case .invalidResponse:
            return "Invalid or malformed server response"
        case .decodingFailed:
            return "Failed to decode the response data"
        case .unauthorized:
            return "Authentication required (401)"
        case .clientError(let statusCode):
            return "Client error (HTTP \(statusCode))"
        case .serverError(let statusCode, let data):
            let dataStr = String(describing: String(data: data, encoding: .utf8))
            return "Server error (HTTP \(statusCode))\nResponse data: \(dataStr)"
        case .unexpectedStatusCode:
            return "Received an unexpected HTTP status code"
        case .notFound:
            return "Resource not found (404)"
        case .notConnectedToInternet:
            return "No internet connection available"
        case .networkConnectionLost:
            return "Network connection was lost during the request"
        case .notImplemented:
            return "The requested operation is not implemented"
        }
    }
}
