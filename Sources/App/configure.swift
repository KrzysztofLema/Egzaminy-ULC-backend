import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                username: "vapor_username",
                password: "vapor_password",
                database: "vapor_database",
                tls: .disable
            )
        ),
        as: .psql
    )

    app.migrations.add(CreateExam())
    
    app.logger.logLevel = .debug
    
    try await app.autoMigrate()
    // register routes
    try routes(app)
}
