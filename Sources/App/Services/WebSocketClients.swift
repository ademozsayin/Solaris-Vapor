//
//  WebSocketClients.swift.swift
//  Solaris-Vapor
//
//  Created by Adem Özsayın on 5.03.2025.
//

import Vapor

/// Actor to manage WebSocket clients safely in a concurrent environment
actor WebSocketClients {
    private var clients: [UUID: WebSocket] = [:]

    func addClient(_ client: WebSocket) -> UUID {
        let id = UUID()
        clients[id] = client
        return id
    }

    func removeClient(_ id: UUID) {
        clients.removeValue(forKey: id)
    }

    func broadcast(_ message: String) {
        for (_, client) in clients {
            client.send(message)
        }
    }
}

// ✅ Create a shared instance
let activeGainerClients = WebSocketClients()
