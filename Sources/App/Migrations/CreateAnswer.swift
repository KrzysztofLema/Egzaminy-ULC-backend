import Fluent

struct CreateAnswer: AsyncMigration {
    private typealias AnswerKey = Answer.Key
    private typealias Schema = Answer.Schema
    private typealias QuestionSchema = Question.Schema

    func prepare(on database: any Database) async throws {
        try await database
            .schema(Schema.title)
            .id()
            .field(AnswerKey.answerText, .string, .required)
            .field(AnswerKey.isCorrect, .bool)
            .field(AnswerKey.questionID, .uuid, .required, .references(QuestionSchema.title, FieldKey.id, onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}
