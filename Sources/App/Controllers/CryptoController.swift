import Vapor

struct CryptoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let crypto = routes.grouped("api")
        crypto.get("gainers", use: fetchTopGainers)
    }

    /// Fetches top 5 gainers from Binance API
    func fetchTopGainers(req: Request) -> EventLoopFuture<[CryptoStats]> {
        let binanceURL = URI(string: "https://api.binance.com/api/v3/ticker/24hr")

        return req.client.get(binanceURL).flatMapThrowing { @Sendable res in
            let allCoins = try res.content.decode([CryptoStats].self)

            let topGainers = allCoins
                .sorted { $0.priceChangePercent > $1.priceChangePercent }
                .prefix(5)
                .map { $0 }

            // ✅ Use Task to make WebSocket calls `@Sendable`
            Task {
                await subscribeToGainerWebSockets(topGainers: Array(topGainers), app: req.application)
            }

            return Array(topGainers)
        }
    }

    /// Subscribe to Binance WebSocket updates for top gainers
    func subscribeToGainerWebSockets(topGainers: [CryptoStats], app: Application) async {
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