//
//  WebSocketResponseDTO.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//


struct WebSocketResponseDTO: Decodable {
    let type: String
    let data: [TradeDTO]?
}

struct TradeDTO: Decodable {
    let symbol: String
    let price: Double
    let timestamp: Double

    enum CodingKeys: String, CodingKey {
        case symbol = "s"
        case price  = "p"
        case timestamp = "t"
    }
}