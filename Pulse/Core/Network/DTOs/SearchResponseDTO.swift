//
//  SearchResponseDTO.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//


struct SearchResponseDTO: Decodable {
    let count: Int
    let result: [AssetDTO]
}

struct AssetDTO: Decodable {
    let symbol: String
    let description: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case description
        case type
    }

    func toDomain() -> Asset {
        Asset(
            id: symbol,
            symbol: symbol,
            name: description,
            type: type.lowercased() == "crypto" ? .crypto : .stock
        )
    }
}