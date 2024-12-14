import Fluent

struct CreateSubject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("subjects")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .field("examID", .uuid, .required, .references("exams", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("subjects").delete()
    }
}
