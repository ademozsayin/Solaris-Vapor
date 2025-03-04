//
//  BinanceHelper.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//


import Vapor

struct BinanceHelper {
    /// Converts a Binance price string to a `Double`
    static func parsePrice(_ priceString: String) -> Double? {
        return Double(priceString)
    }

    /// Formats a price change percentage
    static func formatPercentage(_ percent: String) -> String {
        return "\(percent)%"
    }
    
    /// Returns the correct WebSocket URL for a given type and symbol
    static func getBinanceWebSocketURL(for type: String, symbol: String) -> String? {
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
}
