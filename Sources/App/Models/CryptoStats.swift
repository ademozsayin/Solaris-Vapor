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
}
