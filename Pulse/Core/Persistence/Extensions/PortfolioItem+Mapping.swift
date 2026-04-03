//
//  PortfolioItem+Mapping.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 01/04/2026.
//

import Foundation

extension PortfolioItemMO {
    func toDomain() -> PortfolioItem? {
        guard let assetMO = asset else { return nil }

        let asset = Asset(
            id: assetMO.id ?? "",
            symbol: assetMO.symbol ?? "",
            name: assetMO.name ?? "",
            type: AssetType(rawValue: assetMO.type ?? "") ?? .stock
        )

        return PortfolioItem(
            id: id ?? "",
            asset: asset,
            quantity: quantity,
            averageBuyPrice: averageBuyPrice,
            addedAt: addedAt ?? Date()
        )
    }
}
