//
//  Asset.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//


struct Asset: Hashable, Identifiable {
    let id: String          // symbol acts as ID
    let symbol: String
    let name: String
    let type: AssetType

    static let empty = Asset(id: "", symbol: "", name: "", type: .stock)
}

enum AssetType: String {
    case stock  = "stock"
    case crypto = "crypto"
}
