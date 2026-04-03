//
//  PortfolioRepository.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//

import CoreData

protocol PortfolioRepositoryProtocol {
    func fetchAll() throws -> [PortfolioItem]
    func add(asset: Asset, quantity: Double, buyPrice: Double) throws
    func remove(item: PortfolioItem) throws
    func update(item: PortfolioItem, quantity: Double, buyPrice: Double) throws
}

final class PortfolioRepository: PortfolioRepositoryProtocol {

    private let persistence: PersistenceController

    init(persistence: PersistenceController) {
        self.persistence = persistence
    }

    // MARK: - Fetch

    func fetchAll() throws -> [PortfolioItem] {
        let context = persistence.viewContext
        let request = NSFetchRequest<PortfolioItemMO>(entityName: "PortfolioItemMO")
        request.sortDescriptors = [NSSortDescriptor(key: "addedAt", ascending: false)]
        request.relationshipKeyPathsForPrefetching = ["asset"]  // ← avoid N+1

        let results = try context.fetch(request)
        return results.compactMap { $0.toDomain() }
    }

    // MARK: - Add

    func add(asset: Asset, quantity: Double, buyPrice: Double) throws {
        let context = persistence.newBackgroundContext()

        try context.performAndWait {
            // Fetch or create AssetMO
            let assetMO = try fetchOrCreateAsset(asset, in: context)

            let item = PortfolioItemMO(context: context)
            item.id = UUID().uuidString
            item.quantity = quantity
            item.averageBuyPrice = buyPrice
            item.addedAt = .now
            item.asset = assetMO

            persistence.save(context: context)
        }
    }

    // MARK: - Remove

    func remove(item: PortfolioItem) throws {
        let context = persistence.newBackgroundContext()

        try context.performAndWait {
            let request = NSFetchRequest<PortfolioItemMO>(entityName: "PortfolioItemMO")
            request.predicate = NSPredicate(format: "id == %@", item.id)

            if let mo = try context.fetch(request).first {
                context.delete(mo)
                persistence.save(context: context)
            }
        }
    }

    // MARK: - Update

    func update(item: PortfolioItem, quantity: Double, buyPrice: Double) throws {
        let context = persistence.newBackgroundContext()

        try context.performAndWait {
            let request = NSFetchRequest<PortfolioItemMO>(entityName: "PortfolioItemMO")
            request.predicate = NSPredicate(format: "id == %@", item.id)

            if let mo = try context.fetch(request).first {
                mo.quantity = quantity
                mo.averageBuyPrice = buyPrice
                persistence.save(context: context)
            }
        }
    }

    // MARK: - Helpers

    private func fetchOrCreateAsset(_ asset: Asset, in context: NSManagedObjectContext) throws -> AssetMO {
        let request = NSFetchRequest<AssetMO>(entityName: "AssetMO")
        request.predicate = NSPredicate(format: "id == %@", asset.id)

        if let existing = try context.fetch(request).first {
            return existing
        }

        let mo = AssetMO(context: context)
        mo.id = asset.id
        mo.symbol = asset.symbol
        mo.name = asset.name
        mo.type = asset.type.rawValue
        mo.lastUpdated = .now
        return mo
    }
}
