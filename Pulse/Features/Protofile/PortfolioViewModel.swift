//
//  PortfolioViewModel.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 01/04/2026.
//

import Foundation
import Combine

@MainActor
final class PortfolioViewModel {

    // MARK: - Output
    @Published private(set) var items: [PortfolioItem] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var totalValue: Double = 0

    // MARK: - Private
    private let repository: PortfolioRepositoryProtocol

    init(repository: PortfolioRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Load
    func loadPortfolio() {
        do {
            items = try repository.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Add
    func addAsset(_ asset: Asset, quantity: Double, buyPrice: Double) {
        do {
            try repository.add(asset: asset, quantity: quantity, buyPrice: buyPrice)
            loadPortfolio()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Remove
    func removeItem(_ item: PortfolioItem) {
        do {
            try repository.remove(item: item)
            loadPortfolio()
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }

    // MARK: - Update total value with live prices
    func updateTotalValue(prices: [String: Double]) {
        totalValue = items.reduce(0) { sum, item in
            let price = prices[item.asset?.symbol ?? ""] ?? item.averageBuyPrice
            return sum + item.currentValue(at: price)
        }
    }
}
