//
//  PortfolioItem.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//

import Foundation

struct PortfolioItem: Hashable, Identifiable {
    let id: String
    let asset: Asset?
    let quantity: Double
    let averageBuyPrice: Double
    let addedAt: Date

    // Computed — needs live price injected
    func currentValue(at price: Double) -> Double {
        quantity * price
    }

    func profitLoss(at price: Double) -> Double {
        (price - averageBuyPrice) * quantity
    }

    func profitLossPercent(at price: Double) -> Double {
        ((price - averageBuyPrice) / averageBuyPrice) * 100
    }

    static let empty = PortfolioItem(
        id: "",
        asset: .empty,
        quantity: 0,
        averageBuyPrice: 0,
        addedAt: .now
    )
}
