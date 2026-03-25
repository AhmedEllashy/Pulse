//
//  APIError.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 25/03/2026.
//
import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case serverError(statusCode: Int)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:               return "Invalid URL."
        case .noData:                   return "No data received."
        case .decodingFailed(let e):    return "Decoding failed: \(e.localizedDescription)"
        case .serverError(let code):    return "Server error: \(code)"
        case .unknown(let e):           return e.localizedDescription
        }
    }
}
