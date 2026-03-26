//
//  SearchEndpoint.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//

import Foundation

struct SearchEndpoint: APIEndpoint {
    var baseURL: String { "https://finnhub.io/api/v1" }
    var path: String { "/search" }
    var method: HTTPMethod { .get }
    var headers: [String: String]? { nil }

    let query: String

    var queryItems: [URLQueryItem]? {[
        URLQueryItem(name: "q", value: query),
        URLQueryItem(name: "token", value: APIKeys.finnhub)
    ]}
}
