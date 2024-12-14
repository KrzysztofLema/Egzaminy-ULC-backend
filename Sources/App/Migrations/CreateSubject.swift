import Fluent

struct CreateSubject: AsyncMigration {
    private typealias SubjectKey = Subject.Key
    private typealias Schema = Subject.Schema
    private typealias ExamSchema = Exam.Schema

    func prepare(on database: any Database) async throws {
        try await database.schema(Schema.title)
            .id()
            .field(SubjectKey.title, .string, .required)
            .field(SubjectKey.image, .string, .required)
            .field(SubjectKey.examID, .uuid, .required, .references(ExamSchema.title, FieldKey.id, onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}
