//
//  WebSocketClient.swift
//  Pulse
//
//  Created by Ahmad Ellashy  on 27/03/2026.
//


import Foundation

protocol WebSocketClientProtocol {
    func connect(symbols: [String]) -> AsyncStream<QuoteUpdate>
    func disconnect()
}

final class WebSocketClient: WebSocketClientProtocol {

    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private var continuation: AsyncStream<QuoteUpdate>.Continuation?

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Connect

    func connect(symbols: [String]) -> AsyncStream<QuoteUpdate> {
        AsyncStream { continuation in
            self.continuation = continuation

            let url = URL(string: "wss://ws.finnhub.io?token=\(APIKeys.finnhub)")!
            self.webSocketTask = self.session.webSocketTask(with: url)
            self.webSocketTask?.resume()

            // Subscribe to each symbol
            symbols.forEach { self.subscribe(to: $0) }

            // Start receiving
            self.receiveMessages()

            continuation.onTermination = { [weak self] _ in
                self?.disconnect()
            }
        }
    }

    // MARK: - Disconnect

    func disconnect() {
        symbols.forEach { unsubscribe(from: $0) }
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        continuation?.finish()
    }

    // MARK: - Subscribe

    private var symbols: [String] = []

    private func subscribe(to symbol: String) {
        symbols.append(symbol)
        let message = #"{"type":"subscribe","symbol":"\#(symbol)"}"#
        webSocketTask?.send(.string(message)) { error in
            if let error { print("❌ Subscribe error: \(error)") }
        }
    }

    private func unsubscribe(from symbol: String) {
        let message = #"{"type":"unsubscribe","symbol":"\#(symbol)"}"#
        webSocketTask?.send(.string(message)) { _ in }
    }

    // MARK: - Receive

    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handle(text: text)
                default:
                    break
                }
                // Keep listening
                self?.receiveMessages()

            case .failure(let error):
                print("❌ WebSocket error: \(error)")
                self?.continuation?.finish()
            }
        }
    }

    private func handle(text: String) {
        guard
            let data = text.data(using: .utf8),
            let response = try? JSONDecoder().decode(WebSocketResponseDTO.self, from: data),
            response.type == "trade",
            let trades = response.data
        else { return }

        trades.forEach { trade in
            let update = QuoteUpdate(
                symbol: trade.symbol,
                price: trade.price,
                timestamp: Date(timeIntervalSince1970: trade.timestamp / 1000)
            )
            continuation?.yield(update)
        }
    }
}
