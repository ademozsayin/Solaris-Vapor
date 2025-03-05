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
        
        // ✅ Fetch only USDT pairs
        crypto.get("usdtPairs") { req async throws -> APIResponse<[CryptoStats]> in
            try await self.fetchUSDTPairs(req: req)
        }
        
        // ✅ Fetch top losers
         crypto.get("losers") { req async throws -> APIResponse<[CryptoStats]> in
             try await self.fetchTopLosers(req: req)
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
    
    /// ✅ Fetches only USDT trading pairs
    /// Fetches USDT trading pairs with optional sorting and filtering
    func fetchUSDTPairs(req: Request) async throws -> APIResponse<[CryptoStats]> {
        do {
            let usdtPairs = try await BinanceService.fetchUSDTTradingPairs(client: req.client, req: req)
            return APIResponse(success: true, message: "Fetched USDT pairs successfully", data: usdtPairs)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to fetch USDT pairs: \(error.localizedDescription)")
        }
    }
    
    /// ✅ Fetches top 5 losers from Binance API
    func fetchTopLosers(req: Request) async throws -> APIResponse<[CryptoStats]> {
        do {
            let topLosers = try await BinanceService.fetchTopLosers(client: req.client)
            return APIResponse(success: true, message: "Top losers retrieved successfully", data: topLosers)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to fetch losers: \(error.localizedDescription)")
        }
    }
}
