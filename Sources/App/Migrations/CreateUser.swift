import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("email", .string, .required)
            .unique(on: "email")
            .unique(on: "username")
            .field("profilePicture", .string)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
