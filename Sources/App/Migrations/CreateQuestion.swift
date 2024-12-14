import Fluent

struct CreateQuestion: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("questions")
            .id()
            .field("question_number", .string, .required)
            .field("title", .string, .required)
            .field("subjectID", .uuid, .required, .references("subjects", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("questions").delete()
    }
}
