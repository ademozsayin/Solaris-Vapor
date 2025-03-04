import Vapor

/// ✅ Service to handle Binance API requests & WebSocket connections
struct BinanceService {
    
    /// Fetches top gainers from Binance API
    static func fetchTopGainers(client: Client) -> EventLoopFuture<[CryptoStats]> {
        let binanceURL = URI(string: "https://api.binance.com/api/v3/ticker/24hr")

        return client.get(binanceURL).flatMapThrowing { res in
            let allCoins = try res.content.decode([CryptoStats].self)

            return allCoins
                .sorted { $0.priceChangePercent > $1.priceChangePercent }
                .prefix(5)
                .map { $0 }
        }
    }

    /// Subscribe to Binance WebSocket updates for top gainers
    static func subscribeToGainerWebSockets(topGainers: [CryptoStats], app: Application) async {
        for gainer in topGainers {
            let symbol = gainer.symbol.lowercased()
            let url = "wss://stream.binance.com:9443/ws/\(symbol)@ticker"

            do {
                try await WebSocket.connect(to: url, on: app.eventLoopGroup.next()) { binanceWebSocket in
                    print("✅ Connected to Binance WebSocket for \(symbol)")

                    binanceWebSocket.onText { _, binanceMessage in
                        print("📡 Binance Update for \(symbol): \(binanceMessage)")

                        // Forward Binance updates to all active WebSocket clients
                        Task {
                            await activeGainerClients.broadcast(binanceMessage)
                        }
                    }

                    binanceWebSocket.onClose.whenComplete { _ in
                        print("🔴 Disconnected from Binance WebSocket for \(symbol)")
                    }
                }
            } catch {
                print("❌ Failed to connect to Binance WebSocket for \(symbol): \(error)")
            }
        }
    }
}