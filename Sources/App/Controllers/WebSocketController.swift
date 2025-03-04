//
//  BinanceWebSocketController.swift.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//

import Vapor

import Vapor

struct WebSocketsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("top-gainers", onUpgrade: { req, ws in
            WebSocketService.handleTopGainersWebSocket(clientWebSocket: ws)
        })
        
        routes.webSocket("binance", onUpgrade: { req, ws in
            WebSocketService.handleBinanceWebSocket(req: req, clientWebSocket: ws)
        })
    }
}
