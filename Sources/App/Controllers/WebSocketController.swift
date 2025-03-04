//
//  BinanceWebSocketController.swift.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//

import Vapor

struct WebSocketsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("top-gainers", onUpgrade: handleTopGainersWebSocket)
        routes.webSocket("binance", onUpgrade: handleBinanceWebSocket)
    }

    /// Handles WebSocket connections for top gainers
    func handleTopGainersWebSocket(req: Request, clientWebSocket: WebSocket) {
        Task {
            let clientID = await activeGainerClients.addClient(clientWebSocket)
            print("✅ New WebSocket client connected for top gainers.")

            clientWebSocket.onClose.whenComplete { _ in
                Task {
                    await activeGainerClients.removeClient(clientID)
                    print("🔴 WebSocket client disconnected.")
                }
            }
        }
    }

    /// Handles WebSocket connections for Binance data
    func handleBinanceWebSocket(req: Request, clientWebSocket: WebSocket) {
        guard let type: String = req.query["type"],
              let symbol: String = req.query["symbol"] else {
            clientWebSocket.send("Error: Missing 'type' or 'symbol' query parameter")
            clientWebSocket.close(promise: nil)
            return
        }

        let lowercasedType = type.lowercased()
        let uppercasedSymbol = symbol.uppercased()

        guard let url = getBinanceWebSocketURL(for: lowercasedType, symbol: uppercasedSymbol) else {
            clientWebSocket.send("Error: Unsupported type '\(type)'")
            clientWebSocket.close(promise: nil)
            return
        }

        print("🔗 Connecting to Binance WebSocket: \(url)")

        WebSocket.connect(to: url, on: req.application.eventLoopGroup.next()) { binanceWebSocket in
            print("✅ Connected to Binance WebSocket for \(lowercasedType) - \(uppercasedSymbol)")

            binanceWebSocket.onText { _, binanceMessage in
                clientWebSocket.send(binanceMessage)
            }

            binanceWebSocket.onClose.whenComplete { _ in
                print("🔴 Binance WebSocket closed for \(lowercasedType) - \(uppercasedSymbol)")
                clientWebSocket.close(promise: nil)
            }
        }.whenFailure { error in
            print("❌ Failed to connect to Binance WebSocket: \(error)")
            clientWebSocket.send("Error: Could not connect to Binance WebSocket")
            clientWebSocket.close(promise: nil)
        }
    }
}

/// Maps the `type` to a Binance WebSocket URL
func getBinanceWebSocketURL(for type: String, symbol: String) -> String? {
    switch type {
    case "trades":
        return "wss://stream.binance.com:9443/ws/\(symbol.lowercased())@trade"
    case "ticker":
        return "wss://stream.binance.com:9443/ws/\(symbol.lowercased())@ticker"
    case "depth":
        return "wss://stream.binance.com:9443/ws/\(symbol.lowercased())@depth"
    case "gainers":
        return "wss://stream.binance.com:9443/ws/!miniTicker@arr"
    default:
        return nil
    }
}
