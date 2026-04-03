//
//  Asset+Mapping.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 01/04/2026.
//

import Foundation

extension Asset {
    func toDomain() -> Asset {
        Asset(
            id: id,
            symbol: symbol,
            name: name,
            type: type
        )
    }
}
