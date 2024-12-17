import Fluent

struct CreateExam: AsyncMigration {
    private typealias ExamKey = Exam.Key
    private typealias Schema = Exam.Schema
    private typealias UsersSchema = User.Schema

    func prepare(on database: any Database) async throws {
        try await database.schema(Schema.title)
            .id()
            .field(ExamKey.title, .string, .required)
            .field(ExamKey.subtitle, .string, .required)
            .field(ExamKey.text, .string, .required)
            .field(ExamKey.image, .string, .required)
            .field(ExamKey.background, .string, .required)
            .field(ExamKey.logo, .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Schema.title).delete()
    }
}
