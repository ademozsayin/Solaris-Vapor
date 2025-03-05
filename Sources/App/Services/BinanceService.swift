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
    
    
    
    /// ✅ Fetches top 5 losers
    static func fetchTopLosers(client: Client) async throws -> [CryptoStats] {
        let binanceURL = URI(string: "https://api.binance.com/api/v3/ticker/24hr")

        let response = try await client.get(binanceURL)
        let allCoins = try response.content.decode([CryptoStats].self)

        return allCoins
            .sorted { $0.priceChangePercent < $1.priceChangePercent } // ✅ Sort in ASC order for losers
            .prefix(5)
            .map { $0 }
    }
    
    /// ✅ Fetches USDT trading pairs with sorting and filtering options
    static func fetchUSDTTradingPairs(client: Client, req: Request) async throws -> [CryptoStats] {
        let binanceURL = URI(string: "https://api.binance.com/api/v3/ticker/24hr")

        let response = try await client.get(binanceURL)
        let allPairs = try response.content.decode([CryptoStats].self)

        // ✅ Filter only USDT pairs
        var usdtPairs = allPairs.filter { $0.symbol.hasSuffix("USDT") }

        // ✅ Get query parameters safely
        let count = req.query["count"].flatMap { Int($0) } ?? nil // Number of items
        let gainers = req.query["gainers"].flatMap { Bool($0) } ?? false // Sort by price change
        let losers = req.query["losers"].flatMap { Bool($0) } ?? false // Sort in descending order
        let descending = req.query["desc"].flatMap { Bool($0) } ?? false // Sort alphabetically or numerically

        // ✅ Sorting Logic: Gainers / Losers
        if gainers {
            usdtPairs.sort {
                let first = Double($0.priceChangePercent) ?? 0
                let second = Double($1.priceChangePercent) ?? 0
                return descending ? (first > second) : (first < second)
            }
        } else if losers {
            usdtPairs.sort {
                let first = Double($0.priceChangePercent) ?? 0
                let second = Double($1.priceChangePercent) ?? 0
                return descending ? (first < second) : (first > second)
            }
        } else if descending {
            usdtPairs.sort { $0.symbol > $1.symbol } // Default sorting alphabetically (Z→A)
        }

        // ✅ Limit number of items if `count` parameter exists
        if let count = count, count > 0 {
            usdtPairs = Array(usdtPairs.prefix(count))
        }

        // ✅ Add logos to each coin
        let enrichedPairs = usdtPairs.map { pair in
            CryptoStats(
                symbol: pair.symbol,
                lastPrice: pair.lastPrice,
                priceChangePercent: pair.priceChangePercent,
                imageUrl: CryptoStats.generateImageURL(for: pair.symbol)
            )
        }

        return enrichedPairs
    }
    
}
