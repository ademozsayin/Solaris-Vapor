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
    
    var imageUrl: String {
        let baseCoin = String(symbol.prefix(while: { $0.isLetter }))
        return "https://cryptoicon-api.vercel.app/api/icon/\(baseCoin.lowercased())"
    }
}
