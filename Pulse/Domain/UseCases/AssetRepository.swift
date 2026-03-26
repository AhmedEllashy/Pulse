//
//  AssetRepository.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//


protocol AssetRepositoryProtocol {
    func search(query: String) async throws -> [Asset]
}

final class AssetRepository: AssetRepositoryProtocol {

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func search(query: String) async throws -> [Asset] {
        let response: SearchResponseDTO = try await networkClient.request(
            SearchEndpoint(query: query)
        )
        return response.result.map { $0.toDomain() }
    }
}
