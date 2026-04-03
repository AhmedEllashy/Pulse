//
//  QuoteViewModel.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//


import Foundation

@MainActor
final class QuoteViewModel {

    // MARK: - Output
    @Published private(set) var price: Double = 0
    @Published private(set) var symbol: String = ""
    @Published private(set) var lastUpdated: Date = .now
    @Published private(set) var isConnected: Bool = false

    // MARK: - Private
    private let webSocketClient: WebSocketClientProtocol
    private var streamTask: Task<Void, Never>?

    init(webSocketClient: WebSocketClientProtocol) {
        self.webSocketClient = webSocketClient
    }

    // MARK: - Public

    func startLiveUpdates(for symbol: String) {
        self.symbol = symbol
        isConnected = true

        streamTask = Task {
            let stream = webSocketClient.connect(symbols: [symbol])

            for await update in stream {
                guard !Task.isCancelled else { break }
                price = update.price
                lastUpdated = update.timestamp
            }

            isConnected = false
        }
    }

    func stopLiveUpdates() {
        streamTask?.cancel()
        webSocketClient.disconnect()
        isConnected = false
    }
}
