//
//  ActiveWebSocketSubscriptions.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//


actor ActiveWebSocketSubscriptions {
    private var subscribedSymbols: Set<String> = []

    func isAlreadySubscribed(symbol: String) -> Bool {
        return subscribedSymbols.contains(symbol)
    }

    func addSubscription(symbol: String) {
        subscribedSymbols.insert(symbol)
    }

    func removeSubscription(symbol: String) {
        subscribedSymbols.remove(symbol)
    }
}

// ✅ Create a shared instance to manage WebSocket subscriptions
let activeWebSocketSubscriptions = ActiveWebSocketSubscriptions()
