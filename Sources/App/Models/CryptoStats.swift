//
//  CryptoStats.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 4.03.2025.
//

import Vapor

struct CryptoStats: Content {
    let symbol: String
    let lastPrice: String
    let priceChangePercent: String
    let imageUrl: String? // ✅ Ensure this is part of the struct

    init(symbol: String, lastPrice: String, priceChangePercent: String, imageUrl: String?) {
        self.symbol = symbol
        self.lastPrice = lastPrice
        self.priceChangePercent = priceChangePercent
        self.imageUrl = imageUrl
    }

    /// ✅ Static function to generate the image URL
    static func generateImageURL(for symbol: String) -> String {
        let baseCoin = extractBaseCurrency(from: symbol)
        let fullName = cryptoFullNames[baseCoin] ?? baseCoin.capitalized
        return "https://cryptologos.cc/logos/\(fullName.lowercased())-\(baseCoin.lowercased())-logo.png"
    }

    /// Extracts the base currency (e.g., BTC from BTCUSDT)
    private static func extractBaseCurrency(from symbol: String) -> String {
        let quoteCurrencies = ["USDT", "BTC", "ETH", "BNB", "BUSD", "EUR", "TRY", "USD"]
        for quote in quoteCurrencies {
            if symbol.hasSuffix(quote) {
                return String(symbol.dropLast(quote.count))
            }
        }
        return symbol
    }
}

/// ✅ Mapping of symbol → full name
let cryptoFullNames: [String: String] = [
    "BTC": "Bitcoin",
    "ETH": "Ethereum",
    "BNB": "Binance-Coin",
    "XRP": "XRP",
    "ADA": "Cardano",
    "SOL": "Solana",
    "DOGE": "Dogecoin",
    "DOT": "Polkadot",
    "MATIC": "Polygon",
    "AVAX": "Avalanche",
    "TRX": "Tron",
    "UNI": "Uniswap",
    "LINK": "Chainlink",
    "LTC": "Litecoin",
    "XLM": "Stellar",
    "BCH": "Bitcoin-Cash",
    "ALGO": "Algorand",
    "FTM": "Fantom",
    "AAVE": "Aave",
    "ICP": "Internet-Computer",
    "EOS": "EOS"
]
