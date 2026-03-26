//
//  Quote.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//

import Foundation

struct Quote: Hashable {
    let price: Double
    let change: Double
    let changePercent: Double
    let volume: Double
    let timestamp: Date

    static let empty = Quote(price: 0, change: 0, changePercent: 0, volume: 0, timestamp: .now)
}
