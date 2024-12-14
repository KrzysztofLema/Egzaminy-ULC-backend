import Fluent

struct CreateExam: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("exams")
            .id()
            .field("title", .string, .required)
            .field("subtitle", .string, .required)
            .field("text", .string, .required)
            .field("image", .string, .required)
            .field("background", .string, .required)
            .field("logo", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("exams").delete()
    }
}
