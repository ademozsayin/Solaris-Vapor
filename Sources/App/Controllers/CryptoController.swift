//
//  CryptoController.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//


import Vapor

struct CryptoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let crypto = routes.grouped("api")
        crypto.get("gainers", use: { req async throws -> [CryptoStats] in
          try await self.fetchTopGainers(req: req)
        })
    }

    /// Fetches top 5 gainers from Binance API
    func fetchTopGainers(req: Request) async throws -> [CryptoStats] {
        let topGainers = try await BinanceService.fetchTopGainers(client: req.client)

        // ✅ Move WebSocket subscription to BinanceService
        await BinanceService.subscribeToGainerWebSockets(topGainers: topGainers, app: req.application)

        return topGainers
    }
}
