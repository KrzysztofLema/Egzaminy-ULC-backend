import Fluent

struct CreateQuestion: AsyncMigration {
    private typealias QuestionKey = Question.Key
    private typealias Schema = Question.Schema
    private typealias SubjectSchema = Subject.Schema

    func prepare(on database: any Database) async throws {
        try await database.schema(Schema.title)
            .id()
            .field(QuestionKey.questionNumber, .string, .required)
            .field(QuestionKey.title, .string, .required)
            .field(QuestionKey.subjectID, .uuid, .required, .references(SubjectSchema.title, FieldKey.id, onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}
