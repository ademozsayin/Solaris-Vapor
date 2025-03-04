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
     
        // ✅ Use an explicit `async throws` closure to satisfy `@Sendable`
         crypto.get("gainers") { req async throws -> APIResponse<[CryptoStats]> in
             try await self.fetchTopGainers(req: req)
         }
    }
    
    /// Fetches top 5 gainers from Binance API with a success response
    func fetchTopGainers(req: Request) async throws -> APIResponse<[CryptoStats]> {
        do {
            let topGainers = try await BinanceService.fetchTopGainers(client: req.client)

            // ✅ Return a success response with data
            return APIResponse(success: true, message: "Top gainers retrieved successfully", data: topGainers)

        } catch {
            // ✅ Return an error response
            throw Abort(.internalServerError, reason: "Failed to fetch gainers: \(error.localizedDescription)")
        }
    }
}
