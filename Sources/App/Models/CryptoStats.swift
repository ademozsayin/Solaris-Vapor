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
    var imageUrl: String // ✅ Now explicitly included in the API response

    enum CodingKeys: String, CodingKey {
        case symbol
        case lastPrice
        case priceChangePercent
        case imageUrl
    }

    init(symbol: String, lastPrice: String, priceChangePercent: String) {
        self.symbol = symbol
        self.lastPrice = lastPrice
        self.priceChangePercent = priceChangePercent

        // ✅ Generate the correct image URL from `cryptologos.cc`
        let baseSymbol = symbol.lowercased().replacingOccurrences(of: "usdt", with: "")
        self.imageUrl = "https://cryptologos.cc/logos/\(baseSymbol)-\(baseSymbol)-logo.png"
    }
}
