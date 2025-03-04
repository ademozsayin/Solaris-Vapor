import NIOSSL
import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add(CreateTodo())

    app.views.use(.leaf)

    app.middleware.use(ErrorMiddleware.customMiddleware())
    // register routes
    try routes(app)
}

/// ✅ Custom error middleware to format errors consistently
extension ErrorMiddleware {
    static func customMiddleware() -> ErrorMiddleware {
        return ErrorMiddleware { req, error in
            let response = APIErrorResponse(error.localizedDescription)
            let res = Response(status: .internalServerError)
            try? res.content.encode(response)
            return res
        }
    }
}
