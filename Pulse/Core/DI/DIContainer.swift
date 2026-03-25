//
//  DIContainer.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 25/03/2026.
//

final class DIContainer {

    static let shared = DIContainer()

    // MARK: - Core
    let persistence: PersistenceController
    let networkClient: NetworkClientProtocol

    private init() {
        self.persistence = PersistenceController.shared
        self.networkClient = NetworkClient()
    }
}
