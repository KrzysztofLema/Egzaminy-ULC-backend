import Fluent

struct CreateAnwser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("anwsers")
            .id()
            .field("anwserText", .string, .required)
            .field("isCorrect", .bool, .required)
            .field("questionID", .uuid, .required, .references("questions", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("anwsers").delete()
    }
}
