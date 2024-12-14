import Fluent

struct CreateAnwser: AsyncMigration {
    private typealias AnwserKey = Answer.Key
    private typealias Schema = Answer.Schema
    private typealias QuestionSchema = Question.Schema

    func prepare(on database: any Database) async throws {
        try await database
            .schema(Schema.title)
            .id()
            .field(AnwserKey.anwserText, .string, .required)
            .field(AnwserKey.isCorrect, .bool, .required)
            .field(AnwserKey.questionID, .uuid, .required, .references(QuestionSchema.title, FieldKey.id, onDelete: .cascade))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}
