import Fluent
import Vapor
import NIOConcurrencyHelpers  // ✅ Import for thread-safe handling

func routes(_ app: Application) throws {
    try app.register(collection: CryptoController())
    try app.register(collection: WebSocketsController())
    try app.register(collection: AnnouncementController())
    
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
