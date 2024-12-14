import Fluent

struct CreateSubject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("subjects")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .field("examID", .uuid, .references("exams", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("subjects").delete()
    }
}
