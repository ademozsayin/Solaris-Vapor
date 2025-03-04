//
//  BinanceService.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//


import Vapor

/// ✅ Service to handle Binance API requests & WebSocket connections
struct BinanceService {
    
    /// Fetches top gainers from Binance API
    static func fetchTopGainers(client: Client) async throws -> [CryptoStats] {
        let binanceURL = URI(string: "https://api.binance.com/api/v3/ticker/24hr")

        let response = try await client.get(binanceURL)
        let allCoins = try response.content.decode([CryptoStats].self)

        return allCoins
            .sorted { $0.priceChangePercent > $1.priceChangePercent }
            .prefix(5)
            .map { $0 }
    }


    /// Subscribe to Binance WebSocket updates for top gainers
    /// ✅ Ensure WebSocket subscription is `async`
    static func subscribeToGainerWebSockets(topGainers: [CryptoStats], app: Application) async {
        for gainer in topGainers {
            let symbol = gainer.symbol.lowercased()

            // ✅ Prevent duplicate subscriptions
            if await activeWebSocketSubscriptions.isAlreadySubscribed(symbol: symbol) {
                print("⚠️ Already subscribed to \(symbol), skipping WebSocket connection.")
                continue
            }

            await activeWebSocketSubscriptions.addSubscription(symbol: symbol)

            let url = "wss://stream.binance.com:9443/ws/\(symbol)@ticker"

            do {
                try await WebSocket.connect(to: url, on: app.eventLoopGroup.next()) { binanceWebSocket in
                    print("✅ Connected to Binance WebSocket for \(symbol)")

                    binanceWebSocket.onText { _, binanceMessage in
                        print("📡 Binance Update for \(symbol): \(binanceMessage)")
                        Task {
                            await activeGainerClients.broadcast(binanceMessage)
                        }
                    }

                    binanceWebSocket.onClose.whenComplete { _ in
                        Task {
                            await activeWebSocketSubscriptions.removeSubscription(symbol: symbol)
                        }
                        print("🔴 Disconnected from Binance WebSocket for \(symbol)")
                    }
                }
            } catch {
                print("❌ Failed to connect to Binance WebSocket for \(symbol): \(error)")
            }
        }
    }
}
