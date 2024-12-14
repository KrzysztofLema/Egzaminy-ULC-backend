import Fluent

struct CreateToken: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("tokens")
            .id()
            .field("value", .string, .required)
            .field(
                "userID",
                .uuid,
                .required,
                .references(
                    "users",
                    "id",
                    onDelete: .cascade
                )
            )
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("tokens").delete()
    }
}
