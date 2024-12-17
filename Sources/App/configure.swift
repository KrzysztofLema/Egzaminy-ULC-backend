import Fluent
import FluentPostgresDriver
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    guard let apiKey = Environment.get("API_KEY") else {
        fatalError()
    }

    app.middleware.use(ApiMiddleware(key: apiKey))

    if let databaseURL = Environment.get("DATABASE_URL") {
        try app.databases.use(.postgres(url: databaseURL), as: .psql)
    } else {
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
    }

    app.migrations.add(CreateUser())
    app.migrations.add(CreateExam())
    app.migrations.add(CreateSubject())
    app.migrations.add(CreateQuestion())
    app.migrations.add(CreateAnswer())
    app.migrations.add(CreateToken())
    app.migrations.add(CreateAdminUser())

    app.logger.logLevel = .debug

    try await app.autoMigrate()
    // register routes
    try routes(app)
}
